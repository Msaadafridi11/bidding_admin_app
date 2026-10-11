import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../models/item_model.dart';
import '../../viewmodels/car_list_viewmodel.dart';
import 'admin_add_car_view.dart';
import 'widgets/car_card.dart';

class AdminCarListView extends StatelessWidget {
  const AdminCarListView({super.key});

  void _navigateToEditCar(BuildContext context, ItemModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminAddCarView(item: item),
      ),
    );
  }

  void _navigateToAddCar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminAddCarView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarListViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vehicle Inventory'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: viewModel.refresh,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCar(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Vehicle'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: AppColors.surface,
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search by title, make or model...',
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

                // Filter tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All (${viewModel.totalCount})',
                        isSelected:
                            viewModel.filterStatus == CarFilterStatus.all,
                        onSelected: () =>
                            viewModel.setFilterStatus(CarFilterStatus.all),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Active (${viewModel.activeCount})',
                        isSelected:
                            viewModel.filterStatus == CarFilterStatus.active,
                        onSelected: () =>
                            viewModel.setFilterStatus(CarFilterStatus.active),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Inactive (${viewModel.inactiveCount})',
                        isSelected:
                            viewModel.filterStatus == CarFilterStatus.inactive,
                        onSelected: () =>
                            viewModel.setFilterStatus(CarFilterStatus.inactive),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main content
          Expanded(
            child: _buildBody(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CarListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const LoadingIndicator(message: 'Loading inventory...');
    }

    if (viewModel.errorMessage != null) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    if (viewModel.cars.isEmpty) {
      if (viewModel.searchQuery.isNotEmpty) {
        return EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No Matching Vehicles',
          description:
              'No vehicle matched "${viewModel.searchQuery}". Try a different keyword.',
          actionLabel: 'Clear Search',
          onActionPressed: () => viewModel.setSearchQuery(''),
        );
      }
      return EmptyState(
        icon: Icons.directions_car_filled_outlined,
        title: 'Inventory Is Empty',
        description: 'You have not added any vehicles to the auction system yet.',
        actionLabel: 'Add First Vehicle',
        onActionPressed: () => _navigateToAddCar(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.refresh(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: viewModel.cars.length,
        itemBuilder: (context, index) {
          final car = viewModel.cars[index];
          return CarCard(
            item: car,
            onTap: () => _navigateToEditCar(context, car),
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
