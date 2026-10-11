import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../models/user_model.dart';

class DealerCard extends StatelessWidget {
  final UserModel dealer;
  final VoidCallback onTap;

  const DealerCard({
    super.key,
    required this.dealer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = dealer.isVerified == true;
    final name = dealer.name?.trim().isNotEmpty == true
        ? dealer.name!
        : 'Unnamed Dealer';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'D';

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isVerified
                  ? AppColors.primaryLight
                  : AppColors.warningLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: isVerified
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.warning.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                initial,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isVerified ? AppColors.primary : AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    isVerified
                        ? StatusChip.verified()
                        : StatusChip.unverified(label: 'Pending'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dealer.email ?? 'No email provided',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dealer.compnyName != null &&
                    dealer.compnyName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.business_outlined,
                          size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dealer.compnyName!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
