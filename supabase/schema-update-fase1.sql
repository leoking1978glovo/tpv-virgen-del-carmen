-- Actualización Fase 1 (ejecutar SOLO si ya tienes el esquema base de la v2)

create table if not exists cash_arqueos (
  id bigint generated always as identity primary key,
  closed_at timestamptz not null default now(),
  fondo numeric(10,2) default 0,
  esperado numeric(10,2) default 0,
  contado numeric(10,2) default 0,
  dif numeric(10,2) default 0,
  v_efectivo numeric(10,2) default 0,
  v_tarjeta numeric(10,2) default 0,
  v_bizum numeric(10,2) default 0,
  entradas numeric(10,2) default 0,
  salidas numeric(10,2) default 0,
  ventas_total numeric(10,2) default 0
);

create table if not exists settings (
  key text primary key,
  value text
);

alter table cash_arqueos enable row level security;
alter table settings enable row level security;

create policy "auth_all" on cash_arqueos for all to authenticated using (true) with check (true);
create policy "auth_all" on settings for all to authenticated using (true) with check (true);

insert into settings (key, value) values
 ('businessName', 'Asador de Pollos Virgen del Carmen'),
 ('businessAddr', ''),
 ('businessPhone', ''),
 ('businessNif', ''),
 ('ticketFooter', '¡Gracias por su compra!'),
 ('autoPrintKitchen', '1')
on conflict (key) do nothing;
