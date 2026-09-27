import { createClient } from "@supabase/supabase-js";

export const tpv = createClient(
  import.meta.env.VITE_SUPABASE_URL as string,
  import.meta.env.VITE_SUPABASE_ANON_KEY as string
);

export async function enviarPedidoTPV(p: {
  name: string; phone: string; type: "recogida" | "domicilio";
  addr?: string; pickup?: string; notes?: string;
  items: { name: string; qty: number }[];
}): Promise<{ ok: boolean; id?: number; error?: string }> {
  const { data, error } = await tpv.rpc("place_order", { payload: p });
  if (error) return { ok: false, error: error.message };
  return (data as { ok: boolean; id?: number; error?: string }) ?? { ok: false, error: "respuesta" };
}
