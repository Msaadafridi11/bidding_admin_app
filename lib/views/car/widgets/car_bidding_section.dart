import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/custom_text_field.dart';

class CarBiddingSection extends StatelessWidget {
  final TextEditingController sellerPriceController;
  final TextEditingController minimumBidController;
  final bool isActive;
  final ValueChanged<bool> onActiveChanged;
  final DateTime? bidEndTime;
  final ValueChanged<DateTime?> onBidEndTimeSelected;

  const CarBiddingSection({
    super.key,
    required this.sellerPriceController,
    required this.minimumBidController,
    required this.isActive,
    required this.onActiveChanged,
    required this.bidEndTime,
    required this.onBidEndTimeSelected,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: bidEndTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: bidEndTime != null
          ? TimeOfDay(hour: bidEndTime!.hour, minute: bidEndTime!.minute)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onBidEndTimeSelected(combined);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.surface,
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Auction & Pricing Settings',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price inputs (responsive 2 columns)
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: sellerPriceController,
                  labelText: 'Seller Price (\$)',
                  hintText: 'e.g. 25000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.attach_money_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                      return 'Enter valid amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: minimumBidController,
                  labelText: 'Minimum Bid (\$)',
                  hintText: 'e.g. 5000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: const Icon(Icons.price_change_outlined,
                      color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                      return 'Enter valid amount';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Active auction toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auction Status',
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive
                          ? 'Vehicle is active and accepting bids'
                          : 'Vehicle is inactive (hidden from dealers)',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                Switch(
                  value: isActive,
                  onChanged: onActiveChanged,
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bid End Time Picker
          Text(
            'Auction End Date & Time',
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickDateTime(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bidEndTime != null
                          ? _formatDateTime(bidEndTime!)
                          : 'Select Auction End Date & Time',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: bidEndTime != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontWeight: bidEndTime != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} at $hour:$minute $period';
  }
}
