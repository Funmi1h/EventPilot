create type public.role as enum ('admin', 'organizer'),

create table public.profiles (
    id uuid references auth.users on delete cascade primary key,
    fullname text  not null,
    role public.role default 'organizer'::public.role not null,
    updated_at timestampz default timezone('utc'::text, now()) not null
)

--on active les RLS
ALTER table public.profiles enable row level security;

--politique rls de base 
create policy 'profils visbles  par tous ' on public .profiles for select using (true);
create policy 'modifiable uniquement par le propriétaire du compte ' on public.profiles for update to authenticated using (auth.uid() = id);



--la fonction qui va permettre de mettre les users crée dans la table profils
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'Nouvel Utilisateur'), -- Récupère le nom envoyé par Flutter
    'organizer'::public.user_role                                         -- Rôle par défaut
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

--le trigger pour créer une ligne dans la table profils a chaque inscription

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
