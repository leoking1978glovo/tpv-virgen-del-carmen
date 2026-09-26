-- Actualización Fase 3: stock de productos
alter table products add column if not exists stock int;
-- stock NULL = sin control de stock; un número = unidades disponibles
