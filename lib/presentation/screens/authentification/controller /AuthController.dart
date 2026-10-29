import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  void login(String email, String password){

    //variable reactive pour bloquer le boutton de submission pendant la requete

    if(email.trim().isEmpty || password.trim().isEmpty){
      Get.snackbar(
        'Champs vides', 
        'Veuillez renseigner votre email et votre mot de passe',
        snackPosition: SnackPosition.BOTTOM,
        );

        return;
    }

    try{

    }catch(error){
      Get.snackbar("Erreur de connexion", 
      error.toString().replaceAll('Exception', '')
      );
    }finally{
      isLoading.value= false;
    }


  }
}
