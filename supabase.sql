-- Run in Supabase -> SQL Editor, AFTER creating the admin user (Authentication -> Users)
-- and AFTER disabling public sign-ups (Authentication -> Sign In / Providers).

-- 1) The only editable content: exactly these 7 keys, nothing else can ever be stored.
create table if not exists public.site_details (
  key text primary key check (key in ('location','date','hours','cost','bring','access','contact')),
  value text not null default '' check (char_length(value) <= 400),
  updated_at timestamptz not null default now()
);
insert into public.site_details(key,value) values
 ('location','יבנאל — [פרטי המקום וההגעה]'),('date','[תאריך מלא ושנה — לאישור]'),('hours','[להשלמה]'),
 ('cost','[להשלמה]'),('bring','[להשלמה בהתאם לפעילות]'),('access','[פרטים להשלמה]'),('contact','[שם וטלפון]')
on conflict (key) do nothing;

-- 2) Registrations: anyone may add one, only an admin can read them.
create table if not exists public.registrations (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  data jsonb not null check (pg_column_size(data) < 8000)
);

-- 3) Admins are bound to a fixed account id (auth.uid), not to an email string.
create table if not exists public.admins (uid uuid primary key references auth.users(id) on delete cascade);
insert into public.admins(uid) select id from auth.users where lower(email) = 'zarina1990@gmail.com' on conflict do nothing;

alter table public.site_details enable row level security;
alter table public.registrations enable row level security;
alter table public.admins enable row level security;   -- no policies: nobody can read or write it through the API

create or replace function public.is_admin() returns boolean
language sql security definer set search_path = public stable
as $$ select exists (select 1 from public.admins where uid = auth.uid()) $$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon, authenticated;

create policy "anyone reads details" on public.site_details for select using (true);
create policy "admin writes details" on public.site_details for all
  using (public.is_admin()) with check (public.is_admin());

create policy "anyone registers" on public.registrations for insert with check (true);
create policy "admin reads registrations" on public.registrations for select using (public.is_admin());
