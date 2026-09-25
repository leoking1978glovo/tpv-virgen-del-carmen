# TPV · Asador de Pollos Virgen del Carmen

TPV web para restaurante de comida para llevar. Sin dependencias: HTML + CSS + JS en un solo archivo.
Funciona en cualquier navegador (escritorio, tablet y móvil) e incluye impresión de tickets (80mm).

## Funcionalidades

- **Nuevo pedido**: Recogida / Domicilio / Mostrador, cliente + teléfono, hora de recogida programada, repartidor propio, notas
- **Pedidos**: estados Nuevo → En cocina → Listo → Entregado, edición, cobro
- **Cocina (KDS)**: comandas en tiempo real con tiempo de preparación
- **Caja**: apertura con fondo, movimientos entrada/salida, arqueo de cierre, desglose por método de pago
- **Control**: ventas del día, ticket medio, tiempo medio de preparación, gestión de repartidores
- **Ticket**: impresión automática tras cobro + botón manual (formato térmico 80mm)

## Desarrollo local

Abre `index.html` directamente en el navegador, o sirve la carpeta:

```bash
npx serve .
```

## Despliegue en Vercel

1. Sube este repositorio a GitHub
2. En [vercel.com](https://vercel.com) → **Add New Project** → importa el repo
3. Framework: *Other* · Build: vacío · Output: raíz del proyecto
4. Deploy. Listo: tendrás URL `https://tu-proyecto.vercel.app`

O desde la terminal con Vercel CLI:

```bash
npm i -g vercel
vercel
```

## Roadmap (siguientes pasos)

- [ ] Persistencia real (base de datos Supabase/Postgres)
- [ ] Autenticación de empleados
- [ ] Carta editable desde el propio TPV
- [ ] Impresión directa de comanda en cocina (WebUSB/RAW)
- [ ] Histórico de arqueos y ventas por fechas
