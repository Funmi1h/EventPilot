-- Table des profils utilisateurs
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name text NOT NULL DEFAULT 'Nouvel Utilisateur',
  role text NOT NULL DEFAULT 'organizer',
  updated_at timestamptz DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Activation RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
DROP POLICY IF EXISTS "profils visibles par tous" ON public.profiles;
CREATE POLICY "profils visibles par tous" ON public.profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "modifiable uniquement par le propriétaire du compte" ON public.profiles;
CREATE POLICY "modifiable uniquement par le propriétaire du compte" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id);

-- Fonction trigger pour inserer automatiquement dans profiles a chaque inscription
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'Nouvel Utilisateur'),
    'organizer'
  )
  ON CONFLICT (id) DO UPDATE
  SET full_name = EXCLUDED.full_name;
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger sur auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
