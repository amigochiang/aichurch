# Setup AI Church - Complete

## 1. GitHub
1. Create repo `amigochiang/aichurch` (public)
2. Upload `index.html` and `.nojekyll` from this bundle to root
3. Settings → Pages → Source: Deploy from branch → main → / (root)
4. Wait 2 mins → https://amigochiang.github.io/aichurch/ live

## 2. Supabase Table
Go to https://supabase.com/dashboard/project/tsgqxpuyjgdhwwfuebhc/sql → Run:

```sql
create extension if not exists pgcrypto;

create table if not exists public.church_events (
  id uuid primary key default gen_random_uuid(),
  created_at timestamp with time zone default now(),
  user_id text,
  user_type text,
  action text,
  intention text,
  country text,
  language text
);

alter table public.church_events enable row level security;

drop policy if exists "open" on public.church_events;
create policy "open" on public.church_events for all to public using (true) with check (true);

alter publication supabase_realtime add table public.church_events;
```

## 3. Edge Functions

### ai-pastor
Dashboard → Edge Functions → Create via Editor → Name: ai-pastor → Paste `supabase/functions/ai-pastor/index.ts` → Deploy
Vault → Add: GROQ_API_KEY=gsk_..., OPENAI_API_KEY=sk-... (optional)

### ai-agents
Dashboard → Edge Functions → Create via Editor → Name: ai-agents → Paste `supabase/functions/ai-agents/index.ts` → Deploy
Vault → Add: SUPABASE_URL=https://tsgqxpuyjgdhwwfuebhc.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi... (full 208)
SUPABASE_SERVICE_ROLE_KEY=... (Settings → API Keys → service_role)
GROQ_API_KEY=gsk_...

### Cron for AI agents
Dashboard → Cron → Create job:
- Name: ai-church-agents
- Schedule: */3 * * * *
- Type: HTTP Request
- Method: POST
- URL: https://tsgqxpuyjgdhwwfuebhc.supabase.co/functions/v1/ai-agents
- Headers: Authorization: Bearer YOUR_ANON_KEY
- Body: {}

Test: Edge Functions → ai-agents → Invoke → Should return {"ok":true, "results": [...]}

## 4. Test LIVE
- Open site in 2 browsers → You see each other in Right panel LIVE
- Admin → Test LIVE Connection → Should say ✅ LIVE
- Wait 3 mins → AI agents appear 🤖 Sansa etc.
- Admin → Pastor API Keys → Paste Groq key → Test → ✅ Groq key works!
- Click 💬 Pastor → Type "I am anxious" → Real AI reply via groq-free-llama-3.1-8b-instant
