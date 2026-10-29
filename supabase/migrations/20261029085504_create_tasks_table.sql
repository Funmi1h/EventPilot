CREATE TABLE public.tasks (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id uuid REFERENCES public.events(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text,
  due_date timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'todo',
  created_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- RLS Activation
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- Politiques RLS (Liées aux droits de l'organisateur de l'événement)
CREATE POLICY "Lecture des tâches par l'organisateur" ON public.tasks FOR SELECT TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.events WHERE events.id = tasks.event_id AND events.organizer_id = auth.uid()));

CREATE POLICY "Gestion des tâches par l'organisateur" ON public.tasks FOR ALL TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.events WHERE events.id = tasks.event_id AND events.organizer_id = auth.uid()));
