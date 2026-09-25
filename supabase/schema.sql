-- TPV Virgen del Carmen · Esquema Supabase (v2)
-- Pégalo entero en SQL Editor y pulsa Run

create table products (
  id bigint generated always as identity primary key,
  name text not null,
  price numeric(10,2) not null default 0,
  category text not null default 'General',
  position int not null default 0,
  active boolean not null default true
);

create table drivers (
  id bigint generated always as identity primary key,
  name text not null unique,
  active boolean not null default true
);

create table orders (
  id bigint generated always as identity primary key,
  type text not null check (type in ('recogida','domicilio','mostrador')),
  status text not null default 'nuevo' check (status in ('nuevo','cocina','listo','entregado')),
  name text, phone text, addr text,
  pickup text, driver text, notes text,
  total numeric(10,2) default 0,
  paid boolean default false,
  pay_method text default '',
  created_at timestamptz default now(),
  sent_at timestamptz
);

create table order_items (
  id bigint generated always as identity primary key,
  order_id bigint references orders(id) on delete cascade,
  name text, price numeric(10,2) default 0, qty int default 1
);

create table cash_sessions (
  id bigint generated always as identity primary key,
  fondo numeric(10,2) default 0,
  opened_at timestamptz default now(),
  closed_at timestamptz,
  v_efectivo numeric(10,2) default 0,
  v_tarjeta numeric(10,2) default 0,
  v_bizum numeric(10,2) default 0,
  entradas numeric(10,2) default 0,
  salidas numeric(10,2) default 0
);

create table cash_movements (
  id bigint generated always as identity primary key,
  session_id bigint references cash_sessions(id) on delete cascade,
  tipo text, metodo text default '',
  importe numeric(10,2) default 0,
  nota text default '',
  created_at timestamptz default now()
);

alter table products enable row level security;
alter table drivers enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;
alter table cash_sessions enable row level security;
alter table cash_movements enable row level security;

create policy "auth_all" on products for all to authenticated using (true) with check (true);
create policy "auth_all" on drivers for all to authenticated using (true) with check (true);
create policy "auth_all" on orders for all to authenticated using (true) with check (true);
create policy "auth_all" on order_items for all to authenticated using (true) with check (true);
create policy "auth_all" on cash_sessions for all to authenticated using (true) with check (true);
create policy "auth_all" on cash_movements for all to authenticated using (true) with check (true);

alter publication supabase_realtime add table orders;
alter publication supabase_realtime add table order_items;
alter publication supabase_realtime add table cash_movements;
alter publication supabase_realtime add table products;
alter publication supabase_realtime add table drivers;

insert into products (name, price, category, position) values
('Pollo a l''ast entero', 12.00, 'Lo más pedido', 1),
('Medio pollo a l''ast', 6.50, 'Lo más pedido', 2),
('Cuarto de pollo', 3.80, 'Lo más pedido', 3),
('Menú familiar (pollo + patatas + bebida)', 16.00, 'Lo más pedido', 4),
('Patatas fritas (ración)', 4.00, 'Para acompañar', 5),
('Patatas bravas', 5.00, 'Para acompañar', 6),
('Ensalada mixta', 5.50, 'Para acompañar', 7),
('Croquetas caseras (6 uds)', 7.00, 'Entrantes', 8),
('Ensaladilla rusa', 6.50, 'Entrantes', 9),
('Cerveza (33cl)', 2.00, 'Bebidas', 10),
('Coca-Cola (33cl)', 2.20, 'Bebidas', 11),
('Agua (50cl)', 1.50, 'Bebidas', 12),
('Flan casero', 4.00, 'Postres', 13);

insert into drivers (name) values ('Manolo'), ('Juan');
