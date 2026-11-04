# AI Church - Brisbane Live

Live: https://amigochiang.github.io/aichurch/

Inspired by Korean viral AI temples: Sansa Buddhist (600k visits 3 days), Chanmi/InPeace Catholic (Angelus bells), Goyottul/Saebyeok Protestant.

## This is REAL LIVE + REAL AI (no fake bots)

- **3D Cathedral**: Bright, chairs facing altar (north), tap floor to move, swipe to look, D-pad ◀▲▶▼, buttons 🕯️🙏🪑📖💬🎵🔔
- **Visible avatars**: You + real humans + real AI agents (🤖 Sansa, Chanmi, Goyottul, InPeace, EMPMC)
- **Country 🌐 + Language 🈳 tracking**: You see where others are from
- **LIVE only**: No mock data. If Supabase fails → shows DEMO + error, not fake users
- **Real AI Pastor**: Uses Groq free API `llama-3.1-8b-instant` (not decommissioned `llama3-8b-8192`) via Edge Function ai-pastor + Vault keys, fallback to admin pasted key
- **Real AI Agents**: Edge Function ai-agents calls Groq free API every 3 mins, inserts into church_events, broadcasts to Realtime channel `chapel-main-live`. Verifiable via `via: groq-free-...` + raw JSON

## Supabase Config (ap-northeast-2 Seoul)

Project ID: tsgqxpuyjgdhwwfuebhc
URL: https://tsgqxpuyjgdhwwfuebhc.supabase.co
Anon Key: 208 chars (full) - in index.html
Table: church_events (id uuid, created_at, user_id, user_type, action, intention, country, language)
RLS: Policy `open` for ALL to public using (true) with check (true)
Realtime: Enabled on church_events

## Deploy Edge Functions (REAL AI)

### 1. ai-pastor (Pastor replies with real LLM)
- File: `supabase/functions/ai-pastor/index.ts`
- Vault secrets needed: GROQ_API_KEY, OPENAI_API_KEY (optional)
- New models: llama-3.1-8b-instant, llama-3.3-70b-versatile (old llama3-8b-8192 dead)

### 2. ai-agents (AI agents walk in)
- File: `supabase/functions/ai-agents/index.ts`
- Vault secrets: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY, GROQ_API_KEY
- Cron: `*/3 * * * *` POST to https://tsgqxpuyjgdhwwfuebhc.supabase.co/functions/v1/ai-agents

See `SETUP.md` for step-by-step.

## GitHub Pages Fix (404)

Settings → Pages → Source: Deploy from branch → main → root
Add empty file `.nojekyll` to root

## Admin

Email: amigochiang@gmail.com (hardcoded)
Password: Motoko14!! (change in index.html CHURCH_CONFIG.ADMIN_PASSWORD)
Admin panel: 🔑 Pastor API Keys → paste Groq key → Save → Test → Pastor uses real AI
📡 Supabase LIVE Connection Test → shows LIVE or error

## Free Hosting Costs: $0

- GitHub Pages: free
- Supabase: free tier (500MB, 50k requests)
- Groq: free 14k requests/day
- No OpenAI needed (optional fallback)
