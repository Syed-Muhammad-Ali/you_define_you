import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/auth_api.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String initialEmail;

  const ResetPasswordScreen({
    super.key,
    this.initialEmail = '',
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _emailSent = false;
  String? _errorMessage;
  String? _infoMessage;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Enter your email first so we know where to send the reset details.';
        _infoMessage = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final message = await AuthApi().forgotPassword(email: email);
      if (!mounted) return;
      setState(() {
        _emailSent = true;
        _infoMessage = '$message Check your email for the reset token, then continue to step 2 in the app.';
      });
    } on ApiException catch (apiError) {
      setState(() => _errorMessage = apiError.message);
    } catch (error, stackTrace) {
      debugPrint('Forgot-password error: $error\n$stackTrace');
      setState(() => _errorMessage = 'Unable to contact the server right now. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || token.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Complete every field to reset your password in the app.';
        _infoMessage = null;
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters.';
        _infoMessage = null;
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Password and confirmation must match.';
        _infoMessage = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      final message = await AuthApi().resetPassword(
        email: email,
        token: token,
        password: password,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pop(context, email);
    } on ApiException catch (apiError) {
      setState(() => _errorMessage = apiError.message);
    } catch (error, stackTrace) {
      debugPrint('Reset-password error: $error\n$stackTrace');
      setState(() => _errorMessage = 'Unable to reset your password right now. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = !_loading;
    final headerTitle = _emailSent ? 'ENTER TOKEN\nAND RESET' : 'RESET\nIN THE APP';
    final headerCopy = _emailSent
        ? 'Paste the reset token from your email, then choose your new password.'
        : 'Start with your email. We’ll send the reset details first, then you can finish the reset in the next step.';
    final panelTitle = _emailSent ? 'Step 2 · Finish reset' : 'Step 1 · Verify email';

    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x55FF6B35), Color(0x00FF6B35)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, color: YDYColors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Back to sign in',
                          style: YDYTextStyles.link.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Password Recovery',
                    style: YDYTypography.dmSans(
                      fontSize: 13,
                      color: YDYColors.orange,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    headerTitle,
                    style: YDYTypography.bebasNeue(
                      fontSize: 54,
                      color: YDYColors.white,
                      height: 0.92,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Text(
                      headerCopy,
                      style: YDYTextStyles.body.copyWith(
                        color: const Color(0xCCFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xCC141414),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0x33FFFFFF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 28,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          panelTitle,
                          style: YDYTypography.dmSans(
                            fontSize: 13,
                            color: YDYColors.muted,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          label: 'Email',
                          controller: _emailController,
                          hintText: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_emailSent,
                        ),
                        if (_emailSent) ...[
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'Reset token',
                            controller: _tokenController,
                            hintText: 'Copy and paste token from email',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'New password',
                            controller: _passwordController,
                            hintText: '••••••••',
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'Confirm password',
                            controller: _confirmPasswordController,
                            hintText: '••••••••',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _MessageCard(
                            text: _errorMessage!,
                            color: const Color(0x22E74C3C),
                            borderColor: const Color(0x44E74C3C),
                            textColor: const Color(0xFFFF9B8C),
                          ),
                        ],
                        if (_infoMessage != null) ...[
                          const SizedBox(height: 12),
                          _MessageCard(
                            text: _infoMessage!,
                            color: YDYColors.orangeDim,
                            borderColor: const Color(0x44FF6B35),
                            textColor: YDYColors.white,
                          ),
                        ],
                        const SizedBox(height: 18),
                        if (_emailSent) ...[
                          YDYButton(
                            label: 'Reset password',
                            enabled: canSubmit,
                            loading: _loading,
                            onTap: canSubmit ? _resetPassword : null,
                          ),
                          const SizedBox(height: 10),
                          YDYGhostButton(
                            label: 'Use a different email',
                            onTap: _loading
                                ? null
                                : () {
                                    setState(() {
                                      _emailSent = false;
                                      _tokenController.clear();
                                      _passwordController.clear();
                                      _confirmPasswordController.clear();
                                      _errorMessage = null;
                                      _infoMessage = null;
                                    });
                                  },
                          ),
                        ] else ...[
                          YDYButton(
                            label: 'Send reset email',
                            enabled: canSubmit,
                            loading: _loading,
                            onTap: canSubmit ? _sendResetEmail : null,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: YDYTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: YDYTextStyles.input,
          onEditingComplete: textInputAction == TextInputAction.done ? _resetPassword : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: YDYTextStyles.hint,
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: YDYColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: YDYColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: YDYColors.orange, width: 1.4),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Color textColor;

  const _MessageCard({
    required this.text,
    required this.color,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: YDYTextStyles.body.copyWith(
          color: textColor,
          height: 1.45,
          fontSize: 13,
        ),
      ),
    );
  }
}
