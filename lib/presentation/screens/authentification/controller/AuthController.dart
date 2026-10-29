import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';


class AuthController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;


  void login(String email, String password) async{

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
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

    }catch(error){
      Get.snackbar("Erreur de connexion", 
      error.toString().replaceAll('Exception', '')
      );
    }finally{
      isLoading.value= false;
    }


  }

  Future<void> register(String email, String password, String fullName) async {
  if (email.trim().isEmpty || password.isEmpty || fullName.isEmpty) {
    Get.snackbar(
      'Champs vides',
      'Veuillez renseigner votre adresse e-mail et votre mot de passe.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  try {
    isLoading.value = true;
    errorMessage.value = '';

    await supabase.auth.signUp(
      email: email.trim(),
      password: password,
      
    );

    Get.snackbar(
      'Inscription réussie',
      'Vérifiez votre boîte mail pour confirmer votre adresse.',
    );
  } catch (error) {
    errorMessage.value = error.toString();
    Get.snackbar('Erreur d’inscription', errorMessage.value);
  } finally {
    isLoading.value = false;
  }
}
}
