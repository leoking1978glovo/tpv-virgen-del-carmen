-- Fase A+: fotos locales en Supabase Storage
insert into storage.buckets (id, name, public) values ('productos','productos',true)
on conflict (id) do nothing;

create policy "productos read" on storage.objects for select to anon, authenticated using (bucket_id='productos');
create policy "productos insert" on storage.objects for insert to authenticated with check (bucket_id='productos');
create policy "productos update" on storage.objects for update to authenticated using (bucket_id='productos');
create policy "productos delete" on storage.objects for delete to authenticated using (bucket_id='productos');
