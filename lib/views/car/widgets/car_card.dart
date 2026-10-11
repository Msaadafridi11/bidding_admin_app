import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../models/item_model.dart';

class CarCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const CarCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = item.imageUrls != null && item.imageUrls!.isNotEmpty;
    final firstImageUrl = hasImages ? item.imageUrls!.first : null;
    final isActive = item.isActive == true;

    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image and status badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: AppColors.surfaceMuted,
                  child: firstImageUrl != null
                      ? Image.network(
                          firstImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: isActive
                    ? StatusChip.active(label: 'Active')
                    : StatusChip.inactive(label: 'Inactive'),
              ),
              if (item.year != null)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.year.toString(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title?.isNotEmpty == true
                            ? item.title!
                            : '${item.make ?? ''} ${item.model ?? 'Untitled Vehicle'}',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.sellerPrice != null)
                      Text(
                        '\$${item.sellerPrice!.toStringAsFixed(0)}',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Specs chips row
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (item.make != null && item.make!.isNotEmpty)
                      _buildSpecIcon(Icons.directions_car_filled_outlined, item.make!),
                    if (item.model != null && item.model!.isNotEmpty)
                      _buildSpecIcon(Icons.category_outlined, item.model!),
                    if (item.mileage != null)
                      _buildSpecIcon(Icons.speed_outlined, '${item.mileage} km'),
                    if (item.transmission != null && item.transmission!.isNotEmpty)
                      _buildSpecIcon(Icons.tune_rounded, item.transmission!),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Footer row with date & edit action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.createdAt != null
                          ? 'Listed: ${_formatDate(item.createdAt!)}'
                          : 'ID: ${item.itemId ?? "N/A"}',
                      style: AppTextStyles.bodySmall,
                    ),
                    Row(
                      children: [
                        Text(
                          'Edit Details',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_rounded,
            size: 54,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 6),
          Text(
            'No Image Provided',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecIcon(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.bodySmall),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
