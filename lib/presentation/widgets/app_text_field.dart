import 'package:flutter/material.dart';
import 'package:eventpilot/core/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final bool isUnderline;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.autovalidateMode,
    this.isUnderline = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.isUnderline ? 12.5 : 12.5,
            fontWeight: widget.isUnderline ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: widget.isUnderline ? 0.2 : 0.1,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: widget.isUnderline ? 4 : 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          enabled: widget.enabled,
          autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: widget.isUnderline ? 16.5 : 14.5,
            fontWeight: widget.isUnderline ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.textPrimary,
            height: 1.35,
          ),
          cursorColor: AppColors.ink,
          decoration: widget.isUnderline
              ? InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderStrong, width: 1.4),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderStrong, width: 1.4),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.ink, width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.error, width: 1.4),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.error, width: 2.0),
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.error,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  errorMaxLines: 3,
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            widget.prefixIcon,
                            color: AppColors.textTertiary,
                            size: 18,
                          ),
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textTertiary,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        )
                      : widget.suffixIcon,
                )
              : InputDecoration(
                  hintText: widget.hintText,
                  //affichage net du message d'erreur en rouge sous le champ
                  errorStyle: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.error,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                  errorMaxLines: 3,
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 14, right: 10),
                          child: Icon(
                            widget.prefixIcon,
                            color: AppColors.textTertiary,
                            size: 18,
                          ),
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  suffixIcon: widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textTertiary,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        )
                      : widget.suffixIcon,
                ),
        ),
      ],
    );
  }
}
