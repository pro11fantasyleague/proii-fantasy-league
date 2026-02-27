/**
 * Load Testing Script for ProII Fantasy League Draft
 * 
 * Usage:
 * 1. Install dependencies: npm install @supabase/supabase-js dotenv
 * 2. Create .env file with SUPABASE_URL and SUPABASE_ANON_KEY
 * 3. Run: node load_test_draft.js <LEAGUE_ID> <NUM_CLIENTS>
 */

const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
    console.error('Error: Set SUPABASE_URL and SUPABASE_ANON_KEY in .env');
    process.exit(1);
}

const LEAGUE_ID = process.argv[2];
const NUM_CLIENTS = parseInt(process.argv[3] || '10', 10);

if (!LEAGUE_ID) {
    console.error('Usage: node load_test_draft.js <LEAGUE_ID> [NUM_CLIENTS]');
    process.exit(1);
}

console.log(`Starting load test with ${NUM_CLIENTS} clients for league ${LEAGUE_ID}...`);

const clients = [];

for (let i = 0; i < NUM_CLIENTS; i++) {
    const client = createClient(SUPABASE_URL, SUPABASE_KEY, {
        realtime: {
            params: {
                eventsPerSecond: 10,
            },
        },
    });

    const channel = client.channel(`public:draft_picks:league_id=eq.${LEAGUE_ID}`)
        .on(
            'postgres_changes',
            {
                event: 'INSERT',
                schema: 'public',
                table: 'draft_picks',
                filter: `league_id=eq.${LEAGUE_ID}`,
            },
            (payload) => {
                console.log(`[Client ${i}] Pick received:`, payload.new.player_id);
            }
        )
        .subscribe((status) => {
            if (status === 'SUBSCRIBED') {
                // console.log(`[Client ${i}] Subscribed`);
            }
        });

    clients.push(client);

    // Stagger connections
    if (i % 10 === 0) {
        // console.log(`Connected ${i} clients...`);
    }
}

console.log('All clients initialized. Waiting for events...');

// Keep alive
setInterval(() => {
    console.log('Heartbeat: Connections active.');
}, 10000);
