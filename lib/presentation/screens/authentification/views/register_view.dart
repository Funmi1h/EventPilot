import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/screens/authentification/controller/auth_controller.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //creer le compte dans supabase avec le controller
  void _handleRegister() async {
    if (!_acceptTerms) {
      Get.snackbar(
        'Conditions d\'utilisation',
        'Veuillez accepter les conditions pour continuer.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      await _authController.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NOUVEL ESPACE',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.3,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.9,
                    height: 1.15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Quelques informations, et vos événements trouvent leur place.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 36),

                AppTextField(
                  label: 'Nom complet',
                  hintText: 'Prénom et nom',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Adresse e-mail',
                  hintText: 'vous@exemple.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez renseigner votre e-mail';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Veuillez entrer une adresse valide';
                    }
                    return null;
                  },
                ),
              
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Mot de passe',

                  hintText: 'Votre mot de passe sécurisé',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez définir un mot de passe';
                    }
                    //verification des contraintes sur le mot de passe 
                    if (value.length < 8) {
                      return 'Au moins 8 caractères requis';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Au moins une lettre majuscule requise';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Au moins un chiffre requis';
                    }
                    if (!RegExp(r'[@$!%*?&#^_-]').hasMatch(value)) {
                      return 'Au moins un caractère spécial requis (@\$!%*?&#^_-)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                const Text(
                  'Le mot de passe doit comporter au moins 8 caractères, dont au moins une majuscule, un chiffre et un caractère spécial (@\$!%*?&#^_-).',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textTertiary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Confirmer le mot de passe',
                  hintText: 'Répétez votre mot de passe',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: (val) =>
                            setState(() => _acceptTerms = val ?? true),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'J\'accepte les conditions d\'utilisation et la politique de confidentialité d\'EventPilot.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                Obx(() => AppButton(
                  label: 'Créer mon compte',
                  isLoading: _authController.isLoading.value,
                  onPressed: _handleRegister,
                )),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Déjà un compte ?',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
