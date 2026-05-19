import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${controller.firstName} ${controller.lastName}'.trim();
    final initials = _initials(fullName);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: AppTheme.body(
            size: 15,
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          children: [
            // Avatar + name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orangeBright.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.orangeBright.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: AppTheme.bebas(
                        size: 30,
                        color: AppColors.orangeBright,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    fullName.isEmpty ? 'You' : fullName,
                    style: AppTheme.bebas(
                      size: 26,
                      color: AppColors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.userEmail,
                    style: AppTheme.body(
                      size: 13,
                      color: AppColors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Plan card
            _SectionLabel('Your Plan'),
            const SizedBox(height: 10),
            _PlanCard(controller: controller),

            const SizedBox(height: 32),

            // Account section
            _SectionLabel('Account'),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: controller.userEmail,
            ),

            const SizedBox(height: 32),

            // Sign out
            _OutlineButton(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              color: AppColors.white.withValues(alpha: 0.7),
              onTap: () async {
                Navigator.of(context).pop();
                await controller.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'YO';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTheme.body(
        size: 10.5,
        weight: FontWeight.w700,
        color: AppColors.white.withValues(alpha: 0.3),
      ).copyWith(letterSpacing: 1.4),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final planName = controller.planName;
    final priceLabel = controller.planPriceLabel;
    final hasplan = planName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.orangeBright.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.orangeBright.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orangeBright.withValues(alpha: 0.15),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.orangeBright,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasplan ? planName : 'No active plan',
                  style: AppTheme.body(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                if (priceLabel.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    priceLabel,
                    style: AppTheme.body(
                      size: 12,
                      color: AppColors.orangeBright.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.orangeBright.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Active',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w700,
                color: AppColors.orangeBright,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white.withValues(alpha: 0.4), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.body(
                    size: 10.5,
                    color: AppColors.white.withValues(alpha: 0.35),
                    weight: FontWeight.w600,
                  ).copyWith(letterSpacing: 0.4),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTheme.body(
                    size: 13.5,
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.body(
                size: 14,
                weight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
