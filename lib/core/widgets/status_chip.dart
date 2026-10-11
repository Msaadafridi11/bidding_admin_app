import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum StatusChipType { success, warning, error, info, neutral }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipType type;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusChipType.neutral,
    this.icon,
    this.padding,
  });

  factory StatusChip.verified({String label = 'Verified'}) {
    return StatusChip(
      label: label,
      type: StatusChipType.success,
      icon: Icons.check_circle_rounded,
    );
  }

  factory StatusChip.unverified({String label = 'Not Verified'}) {
    return StatusChip(
      label: label,
      type: StatusChipType.error,
      icon: Icons.cancel_rounded,
    );
  }

  factory StatusChip.active({String label = 'Active'}) {
    return StatusChip(
      label: label,
      type: StatusChipType.success,
      icon: Icons.radio_button_checked_rounded,
    );
  }

  factory StatusChip.inactive({String label = 'Inactive'}) {
    return StatusChip(
      label: label,
      type: StatusChipType.neutral,
      icon: Icons.radio_button_off_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color iconColor;

    switch (type) {
      case StatusChipType.success:
        backgroundColor = AppColors.successLight;
        textColor = const Color(0xFF065F46); // Emerald 800
        iconColor = AppColors.success;
        break;
      case StatusChipType.warning:
        backgroundColor = AppColors.warningLight;
        textColor = const Color(0xFF92400E); // Amber 800
        iconColor = AppColors.warning;
        break;
      case StatusChipType.error:
        backgroundColor = AppColors.errorLight;
        textColor = const Color(0xFF991B1B); // Red 800
        iconColor = AppColors.error;
        break;
      case StatusChipType.info:
        backgroundColor = AppColors.secondaryLight;
        textColor = const Color(0xFF075985); // Sky 800
        iconColor = AppColors.secondary;
        break;
      case StatusChipType.neutral:
        backgroundColor = AppColors.surfaceMuted;
        textColor = AppColors.textSecondary;
        iconColor = AppColors.textMuted;
        break;
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
