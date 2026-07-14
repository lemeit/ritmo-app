# Ritmo — Ayuno intermitente & Agua

PWA minimalista para registrar ayuno intermitente e ingesta de agua. Parte de la familia de apps de Lemeit (junto a PlaN y TrainLog), con datos sincronizados en Supabase.

## Stack

- HTML/CSS/JS vanilla, sin build step.
- [Supabase](https://supabase.com) para auth (magic link) y persistencia de datos.
- Service worker para uso offline de la interfaz (los datos requieren conexión).
- Deploy estático en Cloudflare Pages o GitHub Pages.

## Setup

### 1. Base de datos

Corré `supabase-schema.sql` en el SQL editor del proyecto Supabase (el mismo que usan Training Hub / EMA Saladillo). Crea las tablas `ritmo_ayunos`, `ritmo_agua`, `ritmo_config` con Row Level Security por usuario.

En **Authentication → URL Configuration**, agregá la URL donde vayas a alojar esta app a *Redirect URLs* (por ejemplo `https://ritmo.lemeit.ar`), o el magic link no va a poder volver a la app.

### 2. Credenciales

Editá `config.js` con la URL y anon key del proyecto:

```js
window.RITMO_CONFIG = {
  SUPABASE_URL: 'https://tu-proyecto.supabase.co',
  SUPABASE_ANON_KEY: 'tu-anon-key',
};
```

La anon key es pública por diseño (Supabase la protege con RLS), así que no hay problema en versionarla en un repo privado. Si el repo es público, igual está bien — sin RLS activo no serviría de nada ocultarla, y acá RLS está activo.

### 3. Deploy

Cualquier hosting estático sirve. Con Cloudflare Pages: conectar el repo, build command vacío, output directory `/`.

## Estructura

```
index.html            → app completa (UI + lógica)
config.js              → credenciales Supabase
manifest.json           → metadata PWA (instalación en home screen)
sw.js                   → service worker (cache de assets estáticos)
supabase-schema.sql     → tablas + políticas RLS
marca.svg               → isotipo circular (pulso → hoja)
favicon.svg              → versión cuadrada para favicon/ícono
icon-192.png / icon-512.png → íconos rasterizados para el manifest
```

## Modelo de datos

- **ritmo_ayunos**: cada fila es un ayuno (`inicio`, `fin` nullable mientras está en curso, `meta_horas`).
- **ritmo_agua**: cada trago de agua es una fila propia (`fecha`, `ml`, `hora`) — permite deshacer o editar cualquier entrada, no solo la última.
- **ritmo_config**: metas por usuario (`meta_agua_ml`, `meta_ayuno_horas`, `dias_ayuno` para cuando se sume selección de días de la semana).

## Marca

El isotipo combina una línea de pulso (actividad, naranja `#D85A30`) que en su pico se transforma en una hoja (nutrición, verde `#2A7A6E`) — sin letra todavía, para no forzar un nombre antes de tiempo. Si el proyecto toma nombre propio más adelante, se le puede sumar una letra al lado sin rediseñar el ícono.

## Roadmap

- [x] Persistencia en Supabase + login por magic link
- [ ] Editar hora de inicio/fin de un ayuno ya cargado
- [ ] Seleccionar días de la semana para ayunar
- [ ] Popups con las etapas metabólicas del ayuno (glucógeno, lipólisis, cetosis, autofagia) según el tiempo transcurrido
- [ ] Gráficas históricas (Chart.js) de horas de ayuno y agua por semana/mes
- [ ] Deshacer/editar cualquier entrada de agua (no solo la última)
