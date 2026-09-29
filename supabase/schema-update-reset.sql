-- Reinicio de operativa v3: borra pedidos, caja, arqueos, valoraciones y fichajes
-- Devuelve el recuento exacto de lo borrado. NO toca: products, settings, drivers, staff_roles.
create or replace function public.reset_operativa(pin text)
returns jsonb
language plpgsql
security definer
as $func$
declare
  v_pin text;
  c_orders int; c_items int; c_sess int; c_mov int; c_arq int; c_rev int; c_tc int;
begin
  select value into v_pin from settings where key = 'resetPin';
  if v_pin is null or pin is distinct from v_pin then
    return jsonb_build_object('ok', false, 'error', 'pin');
  end if;

  select count(*) into c_orders from orders;
  select count(*) into c_items from order_items;
  select count(*) into c_sess from cash_sessions;
  select count(*) into c_mov from cash_movements;
  select count(*) into c_arq from cash_arqueos;
  select count(*) into c_rev from reviews;
  select count(*) into c_tc from time_clock;

  delete from order_items where true;
  delete from orders where true;
  delete from cash_movements where true;
  delete from cash_sessions where true;
  delete from cash_arqueos where true;
  delete from reviews where true;
  delete from time_clock where true;

  alter table orders alter column id restart with 1;
  alter table order_items alter column id restart with 1;
  alter table cash_sessions alter column id restart with 1;
  alter table cash_movements alter column id restart with 1;
  alter table cash_arqueos alter column id restart with 1;
  alter table reviews alter column id restart with 1;
  alter table time_clock alter column id restart with 1;

  return jsonb_build_object('ok', true, 'borrados', jsonb_build_object(
    'pedidos', c_orders, 'lineas', c_items, 'sesiones', c_sess,
    'movimientos', c_mov, 'arqueos', c_arq, 'valoraciones', c_rev, 'fichajes', c_tc));
end;
$func$;

grant execute on function public.reset_operativa(text) to authenticated;

insert into settings (key, value) values ('resetPin', '1234')
on conflict (key) do nothing;
