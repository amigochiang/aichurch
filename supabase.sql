-- church_events table
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
