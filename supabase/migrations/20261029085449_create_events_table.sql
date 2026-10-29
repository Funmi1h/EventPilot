CREATE TABLE public.events (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  organizer_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  description text,
  event_type text NOT NULL,
  event_date date NOT NULL,
  event_time time NOT NULL,
  initial_budget numeric(12,2) NOT NULL DEFAULT 0.00,
  is_paid boolean NOT NULL DEFAULT false,
  participation_fee numeric(12,2) NOT NULL DEFAULT 0.00,
  --cette colonne sert a identifier un evenement dans son url publique vu que on ne veut pas utiliser l'id de l'evenement dans une route publique 
  public_token uuid DEFAULT gen_random_uuid() NOT NULL UNIQUE,
  public_url text NOT NULL,
  created_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,

  -- Contraintes de validation métiers
  CONSTRAINT check_initial_budget CHECK (initial_budget >= 0),
  CONSTRAINT check_participation_fee CHECK (
    (is_paid = false AND participation_fee = 0) OR 
    (is_paid = true AND participation_fee > 0)
  )
);

-- RLS Activation
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- Politiques RLS de base
CREATE POLICY "Événements visibles par tous" ON public.events FOR SELECT USING (true);
CREATE POLICY "Insertion réservée aux organisateurs" ON public.events FOR INSERT TO authenticated WITH CHECK (auth.uid() = organizer_id);
CREATE POLICY "Modification par l'organisateur" ON public.events FOR UPDATE TO authenticated USING (auth.uid() = organizer_id);
CREATE POLICY "Suppression par l'organisateur" ON public.events FOR DELETE TO authenticated USING (auth.uid() = organizer_id);
