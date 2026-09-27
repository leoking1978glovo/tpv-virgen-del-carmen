# TPV · Asador de Pollos Virgen del Carmen (v2 + Fase 1 + Fase 2 + Fase 3)

TPV web para comida para llevar con **base de datos real (Supabase)**:
login de empleados, datos persistentes, sincronización en tiempo real entre
dispositivos (caja ↔ cocina) y carta editable desde el propio TPV.

Sin build: HTML + CSS + JS. Despliegue estático en Vercel.

## Puesta en marcha (10 min)

### 1. Supabase
1. Crea el proyecto en [supabase.com](https://supabase.com) (región Frankfurt)
2. **SQL Editor** → pega todo `supabase/schema.sql` → **Run**
3. **Authentication → Users → Add user**: crea un email + contraseña por empleado
4. **Project Settings → API**: copia la **Project URL** y la **anon public key**

### 2. Configurar el TPV
En `index.html`, líneas del bloque `SUPABASE v2` (busca `TU_PROYECTO`):
```js
const SUPABASE_URL = 'https://TU_PROYECTO.supabase.co';
const SUPABASE_ANON_KEY = 'TU_ANON_KEY';
```
Pega tus credenciales. Si las dejas con el placeholder, la app funciona en
**modo local** (todo en memoria, al cerrar se pierde — solo para pruebas).

### 3. GitHub + Vercel
```bash
git add .
git commit -m "v2: Supabase, login y tiempo real"
git push
```
Vercel redespliega automáticamente.

## Flujo de trabajo diario

1. Empleado abre la URL e inicia sesión
2. Abre la caja con el fondo inicial (pestaña Caja)
3. Toma pedidos → envía a cocina → cobra → ticket
4. Cocina ve las comandas en su pantalla en tiempo real
5. Al final del día: arqueo y cierre de caja

## Roadmap

- [ ] Histórico de arqueos consultable
- [ ] Impresión directa de comanda en cocina
- [ ] Pedidos por WhatsApp/teléfono
- [ ] Dominio propio + HTTPS forzado

## Novedades Fase 1

- **Histórico completo**: buscador por nombre/teléfono/nº + filtros por fechas; se cargan todos los pedidos
- **Comanda automática en cocina**: se imprime sola al enviar el pedido (activable en Configuración)
- **Cancelar pedidos** con motivo, quedan archivados
- **Arqueos guardados**: cada cierre queda registrado y consultable en la pestaña Caja
- **Configuración del negocio**: nombre, dirección, teléfono, NIF y pie de ticket editables desde el TPV

### Actualizar una instalación existente
Ejecuta `supabase/schema-update-fase1.sql` en SQL Editor y sube el nuevo `index.html`.

## Novedades Fase 2

- **Modo offline con cola**: si falla el internet, pedidos y movimientos se guardan en cola local y se sincronizan solos al volver (indicador "🔄 N pendientes")
- **Roles**: admin / caja / cocina. El rol cocina solo ve la pestaña Cocina. Se asignan en la tabla `staff_roles` (email + role + nombre). Sin fila = admin
- **Clientes**: escribe un teléfono conocido y autocompleta nombre y dirección
- **Informes** (Control): ventas, ticket medio, top productos y ventas por día, con filtros de fecha y exportación a CSV
- **Fichaje**: botón de entrada/salida del equipo con registro del día

### Actualizar una instalación existente
Ejecuta `supabase/schema-update-fase2.sql` en SQL Editor y sube el nuevo `index.html`.

## Novedades Fase 3

- **PWA instalable**: instala el TPV como app en tablet/móvil (icono propio, pantalla completa). Chrome/Edge: menú ⋮ → "Instalar app" o "Añadir a pantalla de inicio"
- **Arranque sin internet**: el service worker cachea la app; combinado con la cola offline de la Fase 2, el TPV aguanta cortes de conexión
- **Stock básico**: columna `stock` en products (NULL = sin control). Editable en Control → Carta. La tarjeta avisa "Quedan X" (≤5) o "AGOTADO" (0), bloquea añadir más de lo disponible y descuenta al enviar a cocina

### Actualizar una instalación existente
Ejecuta `supabase/schema-update-fase3.sql` y sube `index.html`, `manifest.webmanifest`, `sw.js`, `icon-192.png`, `icon-512.png`.

### Dominio propio (opcional)
Vercel → proyecto → Settings → Domains → añade `tpv.tudominio.es` y sigue las instrucciones DNS (registro A/CNAME). HTTPS automático gratis.

### Impresión térmica directa (opcional, estándar hostelería)
El diálogo de imprimir del navegador sirve para empezar. Para imprimir sin diálogo en impresoras ESC/POS por red/USB:
1. Instala **QZ Tray** (gratis, qz.io) en el PC de la caja
2. Lanza Chrome con `--kiosk-printing` para tickets silenciosos con la impresora por defecto
3. (Avanzado) Integración RAW con QZ Tray vía websockets — consultar cuando se necesite

## Fase A (Qamarero): fotos, panel, sonido y recordatorios

- **Categorías con color** (paleta automática) y **fotos en productos**: campo "URL foto" en Control → Carta. Pega la URL de una imagen (puedes subirla gratis a postimages.org o Imgur) y aparece en la tarjeta del catálogo
- **Panel resumen en Control**: ventas de hoy, pedidos abiertos/cerrados y estado del stock con accesos rápidos a Caja y Nuevo pedido
- **🔊 Sonido al entrar pedido nuevo** (activable en Configuración) — útil con pedidos online
- **Recordatorio de fichaje**: aviso amarillo si olvidaste cerrar el fichaje de la jornada anterior

### Actualizar una instalación existente
Ejecuta `supabase/schema-update-faseA-qm.sql` y sube el nuevo `index.html`.

## Fase B (Qamarero): caja seria

- **Arqueo parcial (X)**: cuenta la caja sin cerrarla — guarda el arqueo, imprime su ticket y reinicia contadores para la siguiente jornada (la caja sigue abierta)
- **Cerrar arqueo y jornada (Z)**: cierra la caja con ticket de jornada que incluye las ventas acumuladas del día
- **🙈 Arqueo ciego** (Configuración): oculta el efectivo esperado para que el empleado cuente sin trampas
- **Propina** guardada en cada pedido (visible en el histórico y en el CSV)
- **Suplemento de domicilio** (Configuración): importe fijo que se suma automático a los pedidos de domicilio
- **Repartidor** visible en las filas del histórico

### Actualizar una instalación existente
Ejecuta `supabase/schema-update-faseB-qm.sql` y sube el nuevo `index.html`.
