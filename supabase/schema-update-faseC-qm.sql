-- Fase C: valoraciones de clientes (QR en ticket)
create table if not exists reviews (
  id bigint generated always as identity primary key,
  order_id bigint,
  rating text check (rating in ('up','down')),
  comment text default '',
  created_at timestamptz default now()
);

alter table reviews enable row level security;
-- Cualquiera (cliente anónimo) puede enviar su valoración...
create policy "public insert" on reviews for insert to anon, authenticated with check (true);
-- ...pero solo los empleados logueados pueden leerlas
create policy "auth read" on reviews for select to authenticated using (true);
