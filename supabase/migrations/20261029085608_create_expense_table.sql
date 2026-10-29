CREATE TABLE public.expenses (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id uuid REFERENCES public.events(id) ON DELETE CASCADE NOT NULL,
  label text NOT NULL,
  amount numeric(12,2) NOT NULL,
  expense_date date NOT NULL DEFAULT current_date,
  created_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,

  CONSTRAINT check_amount CHECK (amount >= 0)
);

-- RLS Activation
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Gestion des dépenses par l'organisateur" ON public.expenses FOR ALL TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.events WHERE events.id = expenses.event_id AND events.organizer_id = auth.uid()));
