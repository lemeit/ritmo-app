-- Ritmo: ayuno intermitente + agua
-- Correr en el SQL editor del mismo proyecto Supabase de Training Hub / EMA.
-- Usa Supabase Auth real (auth.uid()), no el patrón "usuario" texto de las otras apps.

create table if not exists ritmo_ayunos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  inicio timestamptz not null,
  fin timestamptz,
  meta_horas numeric not null default 16,
  creado_en timestamptz not null default now()
);

create table if not exists ritmo_agua (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  fecha date not null default current_date,
  ml integer not null,
  hora timestamptz not null default now()
);

create table if not exists ritmo_config (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  meta_agua_ml integer not null default 2000,
  meta_ayuno_horas numeric not null default 16,
  dias_ayuno int[] not null default '{0,1,2,3,4,5,6}'  -- 0=domingo ... 6=sábado
);

alter table ritmo_ayunos enable row level security;
alter table ritmo_agua   enable row level security;
alter table ritmo_config enable row level security;

create policy "ritmo_ayunos_own" on ritmo_ayunos
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "ritmo_agua_own" on ritmo_agua
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "ritmo_config_own" on ritmo_config
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- índices útiles para las consultas de la app
create index if not exists idx_ritmo_ayunos_user_inicio on ritmo_ayunos (user_id, inicio desc);
create index if not exists idx_ritmo_agua_user_fecha on ritmo_agua (user_id, fecha desc);

-- Importante: en Supabase Auth → URL Configuration, agregar la URL donde
-- vayas a alojar la app (ej. https://ritmo.lemeit.ar) a "Redirect URLs",
-- si no el magic link no va a poder volver a la app.
