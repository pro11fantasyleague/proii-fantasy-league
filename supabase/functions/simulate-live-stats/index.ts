
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

        // Parse Input (Optional match_id or force full simulation)
        // const { match_id } = await req.json()

        // 1. Get List of Active Players (from Team Roster for now)
        // In production, we'd query our master 'players' table or external API by match ID.
        // For MVP Simulation: Pick random players already rostered in the game.
        const { data: rosteredPlayers, error: rosterError } = await supabase
            .from('team_roster')
            .select('player_id')
            .limit(50) // Just a sample

        if (rosterError) throw rosterError
        if (!rosteredPlayers || rosteredPlayers.length === 0) {
            return new Response(
                JSON.stringify({ message: 'No players found to simulate stats for.' }),
                { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
            )
        }

        // 2. Simulate Random Events for ONE Player
        const randomPlayer = rosteredPlayers[Math.floor(Math.random() * rosteredPlayers.length)]
        const playerId = randomPlayer.player_id

        // Get existing stats or init new
        const { data: existingStats, error: fetchError } = await supabase
            .from('player_stats_live')
            .select('*')
            .eq('player_id', playerId)
            .maybeSingle()

        let currentStats = existingStats?.stats || { goals: 0, assists: 0, shots: 0, passes: 0 }

        // Random Event Generator
        const eventType = Math.random()
        let eventDescription = ''

        if (eventType < 0.1) {
            currentStats.goals = (currentStats.goals || 0) + 1
            currentStats.shots = (currentStats.shots || 0) + 1
            eventDescription = 'GOAL!'
        } else if (eventType < 0.2) {
            currentStats.assists = (currentStats.assists || 0) + 1
            eventDescription = 'ASSIST!'
        } else if (eventType < 0.5) {
            currentStats.shots = (currentStats.shots || 0) + 1
            eventDescription = 'Shot on target'
        } else {
            currentStats.passes = (currentStats.passes || 0) + 1
            eventDescription = 'Pass completed'
        }

        // 3. Update Stats Table (Triggers 'realtime_scoring')
        const { error: updateError } = await supabase
            .from('player_stats_live')
            .upsert({
                player_id: playerId,
                match_id: 'sim-match-001',
                stats: currentStats,
                updated_at: new Date().toISOString()
            })

        if (updateError) throw updateError

        return new Response(
            JSON.stringify({
                success: true,
                player: playerId,
                event: eventDescription,
                newStats: currentStats
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
