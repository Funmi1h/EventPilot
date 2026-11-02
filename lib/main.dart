import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_theme.dart';
import 'package:eventpilot/core/routes/app_pages.dart';
import 'package:eventpilot/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Supabase est intentionnellement omis pour le mode démonstration frontend.
  // Décommentez et renseignez vos vraies clés quand le backend est prêt.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EventPilot',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      theme: AppTheme.light,
      // Sur navigateur ou tablette, l'application reste une colonne lisible
      // au lieu de s'étirer sur toute la largeur de l'écran.
      builder: (context, child) {
        return ColoredBox(
          color: const Color(0xFFF0ECE4),
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
