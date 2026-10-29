import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_pages.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import  'package:supabase_flutter/supabase_flutter.dart';
//raccourci pour appeler facilement supabase dans la bd 
final supabase = Supabase.instance.client;
Future<void> main() async {

  //pour charger supabase avant le démarrage
  WidgetsFlutterBinding.ensureInitialized();
  //initialisation de supabase

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']
    );

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
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
    );
  }
}
