CREATE TABLE public.participants (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id uuid REFERENCES public.events(id) ON DELETE CASCADE NOT NULL,
  full_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  registration_status text NOT NULL DEFAULT 'pending',
  created_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.participants ENABLE ROW LEVEL SECURITY;

-- Politiques RLS (Visibles par l'organisateur et insertion publique pour inscription)
CREATE POLICY "Lecture des participants par l'organisateur" ON public.participants FOR SELECT TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.events WHERE events.id = participants.event_id AND events.organizer_id = auth.uid()));

CREATE POLICY "Inscription publique autorisée" ON public.participants FOR INSERT WITH CHECK (true);

CREATE POLICY "Modification par l'organisateur" ON public.participants FOR UPDATE TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.events WHERE events.id = participants.event_id AND events.organizer_id = auth.uid()));
