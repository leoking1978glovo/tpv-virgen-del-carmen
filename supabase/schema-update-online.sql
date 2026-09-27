-- ============================================================
-- PUENTE DE PEDIDOS ONLINE
-- 1) Columna de origen en pedidos
-- 2) Función pública place_order: la web llama aquí (sin login).
--    Valida datos, calcula precios con la BD (no confía en la web),
--    respeta webOpen/webDomicilio y crea el pedido en estado 'nuevo'.
-- ============================================================
alter table orders add column if not exists source text default 'tpv';

create or replace function public.place_order(payload jsonb)
returns jsonb
language plpgsql
security definer
as $func$
declare
  v_name text; v_phone text; v_type text; v_addr text; v_pickup text; v_notes text;
  v_items jsonb; v_item jsonb;
  v_total numeric := 0; v_price numeric; v_fee numeric := 0; v_qty int;
  v_order_id bigint;
begin
  v_name  := left(trim(payload->>'name'), 80);
  v_phone := left(trim(payload->>'phone'), 20);
  v_type  := payload->>'type';
  v_addr  := left(trim(payload->>'addr'), 200);
  v_pickup:= left(trim(payload->>'pickup'), 20);
  v_notes := left(trim(payload->>'notes'), 400);
  v_items := payload->'items';

  if v_name is null or length(v_name) < 2 then
    return jsonb_build_object('ok', false, 'error', 'nombre');
  end if;
  if v_phone is null or length(v_phone) < 6 then
    return jsonb_build_object('ok', false, 'error', 'telefono');
  end if;
  if v_type not in ('recogida','domicilio') then
    return jsonb_build_object('ok', false, 'error', 'tipo');
  end if;
  if v_type = 'domicilio' then
    if v_addr is null or length(v_addr) < 5 then
      return jsonb_build_object('ok', false, 'error', 'direccion');
    end if;
    if coalesce((select value from settings where key='webDomicilio'), '0') <> '1' then
      return jsonb_build_object('ok', false, 'error', 'Solo disponible recogida en local');
    end if;
  end if;
  if v_items is null or jsonb_typeof(v_items) <> 'array'
     or jsonb_array_length(v_items) = 0 or jsonb_array_length(v_items) > 30 then
    return jsonb_build_object('ok', false, 'error', 'pedido');
  end if;
  if coalesce((select value from settings where key='webOpen'), '1') <> '1' then
    return jsonb_build_object('ok', false, 'error', 'closed');
  end if;

  if v_type = 'domicilio' then
    v_fee := coalesce((select nullif(value,'')::numeric from settings where key='deliveryFee'), 0);
  end if;

  v_total := v_fee;
  for v_item in select * from jsonb_array_elements(v_items) loop
    select price into v_price from products
     where active and lower(name) = lower(trim(v_item->>'name'));
    if v_price is null then
      return jsonb_build_object('ok', false, 'error', 'noexiste:' || coalesce(v_item->>'name',''));
    end if;
    v_qty := least(greatest(coalesce((v_item->>'qty')::int, 1), 1), 20);
    v_total := v_total + v_price * v_qty;
  end loop;

  insert into orders (type, status, name, phone, addr, pickup, driver, notes,
                      total, paid, pay_method, source, created_at)
  values (v_type, 'nuevo', v_name, v_phone, v_addr, v_pickup, '', v_notes,
          round(v_total, 2), false, '', 'web', now())
  returning id into v_order_id;

  for v_item in select * from jsonb_array_elements(v_items) loop
    select price into v_price from products
     where active and lower(name) = lower(trim(v_item->>'name'));
    v_qty := least(greatest(coalesce((v_item->>'qty')::int, 1), 1), 20);
    insert into order_items (order_id, name, price, qty)
    values (v_order_id, trim(v_item->>'name'), v_price, v_qty);
  end loop;

  return jsonb_build_object('ok', true, 'id', v_order_id);
end;
$func$;

-- La puerta pública: cualquiera puede EJECUTAR la función, sin leer tablas
grant execute on function public.place_order(jsonb) to anon, authenticated;

-- Ajustes online por defecto
insert into settings (key, value) values
 ('webOpen', '1'),
 ('webDomicilio', '0')
on conflict (key) do nothing;
