import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_theme.dart';
import '../controllers/app_controller.dart';
import '../data/api_config.dart';
import '../data/api_exception.dart';
import '../data/auth_api.dart';
import '../screens/reset_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _loading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final rememberedEmail = widget.controller.rememberedLoginEmail;
    final rememberedPassword = widget.controller.rememberedLoginPassword;
    if (rememberedEmail.isNotEmpty) {
      _emailController.text = rememberedEmail;
    } else if (widget.controller.userEmail.isNotEmpty) {
      _emailController.text = widget.controller.userEmail;
    }
    if (rememberedPassword.isNotEmpty) {
      _passwordController.text = rememberedPassword;
    }
    _rememberMe = widget.controller.rememberSession;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Enter your email and password to continue.');
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final response = await AuthApi().signIn(email: email, password: password);
      await widget.controller.signIn(
        token: response.token,
        email: response.email,
        firstName: response.firstName,
        lastName: response.lastName,
        planKey: response.planKey,
        planName: response.planName,
        planPriceLabel: response.planPriceLabel,
        rememberSession: _rememberMe,
        loginEmail: email,
        loginPassword: password,
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (e, st) {
      debugPrint('Sign-in error: $e\n$st');
      if (mounted) setState(() => _errorMessage = 'Unable to connect. Check your network and try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openSignup() async {
    final uri = Uri.parse(kLandingPageUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      setState(() => _errorMessage = 'Unable to open the sign-up page right now.');
    }
  }

  Future<void> _openForgotPassword() async {
    final email = _emailController.text.trim();
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordScreen(initialEmail: email)),
    );
    if (!mounted || result == null || result.isEmpty) return;
    _emailController.text = result;
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = !_loading &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Top centre orange glow
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 340,
                height: 340,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0x40FF751F), Color(0x00FF751F)],
                  ),
                ),
              ),
            ),
          ),
          // Bottom teal accent
          Positioned(
            bottom: -60,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x1A4A7C7E), Color(0x004A7C7E)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  // Logo
                  Image.asset('assets/logo.png', height: 52, fit: BoxFit.contain),
                  const SizedBox(height: 40),
                  // Headline
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'WELCOME BACK.',
                      style: AppTheme.bebas(
                        size: 64,
                        color: AppColors.white,
                        height: 1,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign in to pick up where you left off.',
                    style: AppTheme.body(
                      size: 14,
                      color: AppColors.dimText,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Email field
                  _Field(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    hint: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                    enabled: !_loading,
                  ),
                  const SizedBox(height: 14),
                  // Password field
                  _Field(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    hint: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => canSubmit ? _submit() : null,
                    enabled: !_loading,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.dimText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Remember me + Forgot password
                  Row(
                    children: [
                      _RememberToggle(
                        value: _rememberMe,
                        enabled: !_loading,
                        onChanged: (v) => setState(() => _rememberMe = v),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _loading ? null : _openForgotPassword,
                        child: Text(
                          'Forgot password?',
                          style: AppTheme.body(
                            size: 13,
                            color: AppColors.orange,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Error
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: const Color(0x18F44336),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0x33F44336)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFFF9B8C), size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTheme.body(
                                size: 13,
                                color: const Color(0xFFFF9B8C),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  // Sign in button
                  _SignInButton(
                    label: 'Sign in & continue',
                    loading: _loading,
                    enabled: canSubmit,
                    onTap: canSubmit ? _submit : null,
                  ),
                  const SizedBox(height: 28),
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: const Color(0x1AFFFFFF))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'New here?',
                          style: AppTheme.body(size: 12, color: AppColors.dimText),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: const Color(0x1AFFFFFF))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Create account
                  GestureDetector(
                    onTap: _openSignup,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0x33FFFFFF)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Create an account →',
                          style: AppTheme.body(
                            size: 14,
                            color: AppColors.white,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: AppTheme.body(size: 15, color: AppColors.white, weight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.body(size: 15, color: AppColors.dimText),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: Icon(icon, color: AppColors.dimText, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon != null
            ? Padding(padding: const EdgeInsets.only(right: 16), child: suffixIcon)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFF181818),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1E1E1E)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}

class _RememberToggle extends StatelessWidget {
  const _RememberToggle({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? AppColors.orange : const Color(0xFF3A3A3A),
                width: 1.5,
              ),
            ),
            child: value
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            'Remember me',
            style: AppTheme.body(size: 13, color: AppColors.softText),
          ),
        ],
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.label,
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF5E1F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled ? null : const Color(0xFF252525),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.orange.withAlpha(60),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: AppTheme.body(
                    size: 15,
                    color: enabled ? AppColors.white : AppColors.dimText,
                    weight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
