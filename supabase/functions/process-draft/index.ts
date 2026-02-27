
// @ts-ignore
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
// @ts-ignore
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req: Request) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      // @ts-ignore
      Deno.env.get('SUPABASE_URL') ?? '',
      // @ts-ignore
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { league_id } = await req.json()

    if (!league_id) {
      throw new Error('Missing league_id')
    }

    // 1. Fetch League State
    const { data: league, error: leagueError } = await supabase
      .from('leagues')
      .select('*')
      .eq('id', league_id)
      .single()

    if (leagueError || !league) {
        throw new Error('League not found')
    }

    // 2. Check if Draft is Live and Timer Expired
    // This assumes league table has: 'current_pick_deadline', 'draft_status', 'turn_index'
    // (We need to ensure DB schema matches this expectation)
    const now = new Date()
    const deadline = new Date(league.current_pick_deadline) // e.g. timestamp

    if (league.draft_status === 'live' && now > deadline) {
        // TIMER EXPIRED -> AUTO PICK

        // 3. Find Available Player (Mock Logic: pick random or top remaining)
        // In real app: Get remaining players, sort by rank/ADP, pick first.
        // Simplified: Insert a placeholder or random ID.
        const mockPlayerId = 'auto-picked-player-' + Date.now(); 

        // 4. Update Draft Picks
        const { error: pickError } = await supabase
            .from('draft_picks')
            .insert({
                league_id: league_id,
                player_id: mockPlayerId,
                pick_number: league.config_current_pick_index + 1, // field name assumed
                is_auto_picked: true
            })

        if (pickError) throw pickError

        // 5. Advance Turn
        // Calculate new deadline (e.g. +60 seconds)
        const newDeadline = new Date(now.getTime() + 60000).toISOString()
        
        await supabase
            .from('leagues')
            .update({
                current_pick_deadline: newDeadline,
                config_current_pick_index: league.config_current_pick_index + 1
            })
            .eq('id', league_id)
        
        return new Response(
            JSON.stringify({ message: 'Auto-pick processed', player: mockPlayerId }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
    }

    // 6. If Timer Not Expired
    return new Response(
      JSON.stringify({ 
          message: 'Draft in progress', 
          timeLeft: Math.max(0, (deadline.getTime() - now.getTime()) / 1000) 
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error: any) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
    )
  }
})
