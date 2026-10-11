import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../models/user_model.dart';
import '../../viewmodels/dealer_viewmodel.dart';
import 'dealer_details_view.dart';
import 'widgets/dealer_card.dart';

class DealerListView extends StatelessWidget {
  const DealerListView({super.key});

  void _navigateToDetails(BuildContext context, UserModel dealer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DealerDetailsView(dealerData: dealer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DealerViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dealer Registrations'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: viewModel.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email, or company...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textMuted, size: 20),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => viewModel.setSearchQuery(''),
                          )
                        : null,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    fillColor: AppColors.surfaceMuted,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All (${viewModel.totalCount})',
                        isSelected:
                            viewModel.filterStatus == DealerFilterStatus.all,
                        onSelected: () =>
                            viewModel.setFilterStatus(DealerFilterStatus.all),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Pending (${viewModel.pendingCount})',
                        isSelected: viewModel.filterStatus ==
                            DealerFilterStatus.unverified,
                        onSelected: () => viewModel
                            .setFilterStatus(DealerFilterStatus.unverified),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Verified (${viewModel.verifiedCount})',
                        isSelected: viewModel.filterStatus ==
                            DealerFilterStatus.verified,
                        onSelected: () => viewModel
                            .setFilterStatus(DealerFilterStatus.verified),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main body
          Expanded(
            child: _buildBody(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, DealerViewModel viewModel) {
    if (viewModel.isLoading) {
      return const LoadingIndicator(message: 'Loading dealer records...');
    }

    if (viewModel.errorMessage != null) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    if (viewModel.dealers.isEmpty) {
      if (viewModel.searchQuery.isNotEmpty) {
        return EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No Matching Dealers',
          description:
              'No dealer matched "${viewModel.searchQuery}". Try a different keyword.',
          actionLabel: 'Clear Search',
          onActionPressed: () => viewModel.setSearchQuery(''),
        );
      }
      return const EmptyState(
        icon: Icons.group_off_rounded,
        title: 'No Dealers Found',
        description: 'No dealer accounts exist under this filter category.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.refresh(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: viewModel.dealers.length,
        itemBuilder: (context, index) {
          final dealer = viewModel.dealers[index];
          return DealerCard(
            dealer: dealer,
            onTap: () => _navigateToDetails(context, dealer),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceMuted,
      labelStyle: AppTextStyles.labelSmall.copyWith(
        color: isSelected ? Colors.white : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
