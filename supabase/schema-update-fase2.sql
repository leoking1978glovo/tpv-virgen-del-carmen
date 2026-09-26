-- Actualización Fase 2: roles y fichaje
create table if not exists staff_roles (
  email text primary key,
  role text not null default 'caja' check (role in ('admin','caja','cocina')),
  name text
);

create table if not exists time_clock (
  id bigint generated always as identity primary key,
  email text,
  name text,
  action text check (action in ('in','out')),
  at timestamptz default now()
);

alter table staff_roles enable row level security;
alter table time_clock enable row level security;

create policy "auth_all" on staff_roles for all to authenticated using (true) with check (true);
create policy "auth_all" on time_clock for all to authenticated using (true) with check (true);
