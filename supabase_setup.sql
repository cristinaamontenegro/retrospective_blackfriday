-- Setup for the Black Friday Icebreaker votes table.
-- Run this in the Supabase Dashboard: SQL Editor -> New query -> paste -> Run.

create table if not exists public.votes (
  uid text primary key,
  shopper text,
  sticker text,
  at timestamptz not null default now()
);

alter table public.votes enable row level security;

-- Anyone with the anon (publishable) key can read results,
-- and insert/update their own vote row (open by design for the retro).
create policy "anon can read votes" on public.votes
  for select to anon using (true);

create policy "anon can insert votes" on public.votes
  for insert to anon with check (true);

create policy "anon can update votes" on public.votes
  for update to anon using (true) with check (true);
