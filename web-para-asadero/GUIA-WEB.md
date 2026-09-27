# Conectar la web de pedidos con el TPV

1. En la carpeta del repo `asadero-virgen-del-carmen`: `npm i @supabase/supabase-js`
2. Copia `.env` a la raíz del repo (y añade las dos variables en Vercel → proyecto → Settings → Environment Variables)
3. Copia `tpv.ts` a `src/lib/tpv.ts`
4. En `src/components/CartDrawer.tsx`, debajo del total añade el botón "Pedir online (recogida)":
   - Pide: nombre, teléfono, hora de recogida (select "Lo antes posible" + franjas de 15 min 11:00-15:00 y 19:00-22:30), notas opcionales
   - Al confirmar: `enviarPedidoTPV({ name, phone, type: "recogida", pickup, notes, items: items.map(i => ({ name: i.name, qty: i.quantity })) })`
   - Si ok → `clearCart()` + mensaje "Pedido #ID confirmado, págalo al recoger"
   - Si error === "closed" → "Ahora mismo no aceptamos pedidos online"
   - Deja el botón de WhatsApp como opción secundaria
5. IMPORTANTE: los nombres de producto de la web deben coincidir EXACTAMENTE con los de la carta del TPV
   (la función calcula el precio en el servidor por nombre)
6. git add . / commit / push → Vercel redespliega solo

Pedido de prueba: abre la web, pide algo, y mira el TPV → Pedidos (debe entrar con chip 🌐 WEB).
