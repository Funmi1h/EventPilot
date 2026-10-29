CREATE TABLE public.payments (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  participant_id uuid REFERENCES public.participants(id) ON DELETE CASCADE NOT NULL,
  amount numeric(12,2) NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  payment_date timestamptz,
  created_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,

  CONSTRAINT check_payment_amount CHECK (amount >= 0)
);

-- RLS Activation
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Lecture des paiements par l'organisateur" ON public.payments FOR SELECT TO authenticated 
  USING (EXISTS (
    SELECT 1 FROM public.participants p
    JOIN public.events e ON e.id = p.event_id
    WHERE p.id = payments.participant_id AND e.organizer_id = auth.uid()
  ));

CREATE POLICY "Création de paiement simulé automatique" ON public.payments FOR INSERT WITH CHECK (true);
