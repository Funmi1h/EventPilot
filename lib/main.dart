import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/theme/app_theme.dart';
import 'package:eventpilot/core/routes/app_pages.dart';
import 'package:eventpilot/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //charger les variables d'environnement
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    //si .env n'est pas present on utilisera les valeurs par defaut
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ??
      'https://pocuoksenyqbpzbnfqlk.supabase.co';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ??
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  //initialiser supabase avant de demarrer les ecrans
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    //eviter de bloquer si supabase est deja initialise
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EventPilot',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      theme: AppTheme.light,
      //garder une largeur lisible sur le web
      builder: (context, child) {
        return ColoredBox(
          color: AppColors.frameBackground,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
