-- Fase B (estilo Qamarero): propina, tipo de arqueo X/Z
alter table orders add column if not exists tip numeric(10,2) default 0;
alter table cash_arqueos add column if not exists kind text default 'X';
