import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../models/user_model.dart';
import '../../viewmodels/dealer_viewmodel.dart';

class DealerDetailsView extends StatefulWidget {
  final UserModel? dealerData;

  const DealerDetailsView({
    super.key,
    this.dealerData,
  });

  @override
  State<DealerDetailsView> createState() => _DealerDetailsViewState();
}

class _DealerDetailsViewState extends State<DealerDetailsView> {
  String? get dealerUid => widget.dealerData?.uid;

  void _onApprove(DealerViewModel viewModel) {
    if (dealerUid == null || dealerUid!.isEmpty) {
      _showSnackbar('Dealer UID is missing');
      return;
    }

    ConfirmationDialog.show(
      context,
      title: 'Approve Dealer',
      message:
          'Are you sure you want to verify and grant auction access to this dealer?',
      confirmText: 'Approve',
      confirmColor: AppColors.success,
      icon: Icons.check_circle_rounded,
      onConfirm: () async {
        final success = await viewModel.approveDealer(dealerUid!);
        if (mounted) {
          if (success) {
            _showSnackbar('Dealer approved successfully', isError: false);
            Navigator.pop(context, true);
          } else {
            _showSnackbar(viewModel.errorMessage ?? 'Failed to approve dealer');
          }
        }
      },
    );
  }

  void _onReject(DealerViewModel viewModel) {
    if (dealerUid == null || dealerUid!.isEmpty) {
      _showSnackbar('Dealer UID is missing');
      return;
    }

    ConfirmationDialog.show(
      context,
      title: 'Reject Dealer',
      message:
          'Are you sure you want to reject this dealer request? This will remove the account registration.',
      confirmText: 'Reject',
      confirmColor: AppColors.error,
      icon: Icons.cancel_rounded,
      onConfirm: () async {
        final success = await viewModel.rejectDealer(dealerUid!);
        if (mounted) {
          if (success) {
            _showSnackbar('Dealer request rejected', isError: false);
            Navigator.pop(context, true);
          } else {
            _showSnackbar(viewModel.errorMessage ?? 'Failed to reject dealer');
          }
        }
      },
    );
  }

  void _showSnackbar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dealer = widget.dealerData;
    if (dealer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dealer Details')),
        body: const Center(child: Text('No dealer data found')),
      );
    }

    final viewModel = context.watch<DealerViewModel>();
    final isVerified = dealer.isVerified == true;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dealer Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top verification header card
                CustomCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isVerified
                              ? AppColors.successLight
                              : AppColors.warningLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isVerified
                              ? Icons.verified_user_rounded
                              : Icons.pending_actions_rounded,
                          size: 48,
                          color: isVerified
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dealer.name ?? 'Unnamed Dealer',
                        style: AppTextStyles.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dealer.email ?? 'No email provided',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      isVerified
                          ? StatusChip.verified(label: 'Account Verified')
                          : StatusChip.unverified(label: 'Pending Verification'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Details Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name',
                        value: dealer.name ?? 'N/A',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        value: dealer.email ?? 'N/A',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.business_outlined,
                        label: 'Company Name',
                        value: dealer.compnyName ?? 'N/A',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: dealer.phoneNum != null
                            ? dealer.phoneNum.toString()
                            : 'N/A',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.fingerprint_rounded,
                        label: 'User UID',
                        value: dealer.uid ?? 'N/A',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Verification action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Approve',
                        onPressed: (viewModel.isBusy || isVerified)
                            ? null
                            : () => _onApprove(viewModel),
                        isLoading: viewModel.isApproving,
                        variant: CustomButtonVariant.success,
                        icon: const Icon(Icons.check_circle_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: CustomButton(
                        label: 'Reject',
                        onPressed: viewModel.isBusy
                            ? null
                            : () => _onReject(viewModel),
                        isLoading: viewModel.isRejecting,
                        variant: CustomButtonVariant.danger,
                        icon: const Icon(Icons.cancel_rounded, size: 20),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
