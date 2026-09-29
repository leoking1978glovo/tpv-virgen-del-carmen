-- Botón de reinicio protegido con PIN: borra SOLO pedidos, caja, arqueos y valoraciones
-- NO toca: products (carta), settings (configuración), drivers, staff_roles, time_clock
create or replace function public.reset_operativa(pin text)
returns jsonb
language plpgsql
security definer
as $func$
declare
  v_pin text;
begin
  select value into v_pin from settings where key = 'resetPin';
  if v_pin is null or pin is distinct from v_pin then
    return jsonb_build_object('ok', false, 'error', 'pin');
  end if;

  delete from order_items;
  delete from orders;
  delete from cash_movements;
  delete from cash_sessions;
  delete from cash_arqueos;
  delete from reviews;

  alter table orders alter column id restart with 1;
  alter table order_items alter column id restart with 1;
  alter table cash_sessions alter column id restart with 1;
  alter table cash_movements alter column id restart with 1;
  alter table cash_arqueos alter column id restart with 1;
  alter table reviews alter column id restart with 1;

  return jsonb_build_object('ok', true);
end;
$func$;

grant execute on function public.reset_operativa(text) to authenticated;

-- PIN por defecto (cámbialo en el TPV: Control -> Configuración)
insert into settings (key, value) values ('resetPin', '1234')
on conflict (key) do nothing;
