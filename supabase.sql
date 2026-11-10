-- Run once in Supabase -> SQL Editor.
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

-- 2) Registrations: anyone may add one, only the admin can read them.
create table if not exists public.registrations (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  data jsonb not null check (pg_column_size(data) < 8000)
);

alter table public.site_details enable row level security;
alter table public.registrations enable row level security;

create policy "anyone reads details" on public.site_details for select using (true);
create policy "admin writes details" on public.site_details for all
  using (lower(auth.jwt()->>'email') = 'zarina1990@gmail.com')
  with check (lower(auth.jwt()->>'email') = 'zarina1990@gmail.com');

create policy "anyone registers" on public.registrations for insert with check (true);
create policy "admin reads registrations" on public.registrations for select
  using (lower(auth.jwt()->>'email') = 'zarina1990@gmail.com');
