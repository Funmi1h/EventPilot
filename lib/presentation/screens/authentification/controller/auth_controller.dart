import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;


  Future<void> login(String email, String password) async{

    //variable reactive pour bloquer le boutton de submission pendant la requete

    if(email.trim().isEmpty || password.trim().isEmpty){
      Get.snackbar(
        'Champs vides', 
        'Veuillez renseigner tous les champs de connexion',
        snackPosition: SnackPosition.BOTTOM,
        );

        return;
    }

    try{
    
      isLoading.value = true;
      errorMessage.value = '';

      // connexion par email et mot de passe 
      final response = await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
      );
      if(response.user != null){
        //on redirige en meme temps vers le dashboard

        Get.offAllNamed(AppRoutes.dashboardOrganizer);
      }


    }on AuthException catch(error){
      Get.snackbar('Erreur de connexion', error.message, snackPosition: SnackPosition.BOTTOM,);

    }catch(error){
      Get.snackbar("Erreur de connexion", error.toString(), snackPosition: SnackPosition.BOTTOM
      );
    }finally{
      isLoading.value= false;
    }


  }

  Future<void> register(String email, String password, String fullName) async {
    if (email.trim().isEmpty || password.isEmpty || fullName.isEmpty) {
      Get.snackbar(
        'Champs vides',
        'Veuillez remplir tous les champs.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    //on vérifie que le mot de passe contient au moins 8 caracteres dont au moins un chiffres au m
    final String passwordText = password;
    final RegExp passwordValidator = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordValidator.hasMatch(passwordText)) {
      Get.snackbar(
        'Mot de passe trop faible',
        'Le mot de passe doit contenir au moins 8 caractères, dont une majuscule, un chiffre et un caractère spécial (@\$!%*?&).',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return;
    }


    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
      if(response.user != null){
        Get.snackbar(
          'Inscription réussie',
          'Vérifiez votre boîte mail pour confirmer votre adresse.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
        Get.offAllNamed(AppRoutes.login);

      }
   
  } on AuthException catch(error){
      Get.snackbar('Erreur d\'inscription', error.message, snackPosition: SnackPosition.BOTTOM,);

    }catch(error){
      Get.snackbar("Erreur d'inscription", error.toString(), snackPosition: SnackPosition.BOTTOM
      );
    } finally {
    isLoading.value = false;
  }
}

Future<void> logout()async{
  try{
    await supabase.auth.signOut();
  Get.offAllNamed(AppRoutes.login);

  }catch(error){
    Get.snackbar('Erreur', 'Impossible de se déconnecter', snackPosition:SnackPosition.BOTTOM,);
  }
  
}
}
