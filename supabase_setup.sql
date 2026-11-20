-- RP Team Holidays calendar
-- Run this script in Supabase Dashboard > SQL Editor.

create table if not exists public.rp_team_holidays (
  id uuid primary key default gen_random_uuid(),
  holiday_date date not null,
  team_member text not null check (char_length(trim(team_member)) between 1 and 50),
  created_at timestamptz not null default now()
);

-- Prevent duplicate names on the same date (case-insensitive).
create unique index if not exists rp_team_holidays_date_member_unique
  on public.rp_team_holidays (holiday_date, lower(team_member));

alter table public.rp_team_holidays enable row level security;

-- This policy makes the calendar publicly readable/editable by anyone
-- who can access the published page and its public key.
-- Use Supabase Auth + user-specific policies if this should be private.
drop policy if exists "Public can read RP team holidays" on public.rp_team_holidays;
create policy "Public can read RP team holidays"
  on public.rp_team_holidays for select to anon using (true);

drop policy if exists "Public can add RP team holidays" on public.rp_team_holidays;
create policy "Public can add RP team holidays"
  on public.rp_team_holidays for insert to anon with check (true);

drop policy if exists "Public can remove RP team holidays" on public.rp_team_holidays;
create policy "Public can remove RP team holidays"
  on public.rp_team_holidays for delete to anon using (true);

-- Enable Realtime updates for this table.
do $$
begin
  alter publication supabase_realtime add table public.rp_team_holidays;
exception
  when duplicate_object then null;
  when undefined_object then
    raise notice 'Publication supabase_realtime not found; enable Realtime for this table in the Supabase Dashboard.';
end $$;
