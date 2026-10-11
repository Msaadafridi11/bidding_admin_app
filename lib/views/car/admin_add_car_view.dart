import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/item_model.dart';
import '../../viewmodels/car_form_viewmodel.dart';
import '../dashboard/bottom_navigation_view.dart';
import 'widgets/car_bidding_section.dart';
import 'widgets/car_image_picker_section.dart';

class AdminAddCarView extends StatelessWidget {
  final ItemModel? item;

  const AdminAddCarView({
    super.key,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CarFormViewModel>(
      create: (_) => CarFormViewModel(item: item),
      child: _AdminAddCarForm(item: item),
    );
  }
}

class _AdminAddCarForm extends StatefulWidget {
  final ItemModel? item;

  const _AdminAddCarForm({this.item});

  @override
  State<_AdminAddCarForm> createState() => _AdminAddCarFormState();
}

class _AdminAddCarFormState extends State<_AdminAddCarForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _modelController = TextEditingController();
  final _makeController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _registeredInController = TextEditingController();
  final _bodyTypeController = TextEditingController();
  final _engineSizeController = TextEditingController();
  final _enteriorColorController = TextEditingController();
  final _exteriorColorController = TextEditingController();
  final _firstOwnerController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _safetyBeltController = TextEditingController();
  final _specificationController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _trimController = TextEditingController();
  final _carOptionsController = TextEditingController();
  final _keysController = TextEditingController();
  final _numberOfCylindersController = TextEditingController();
  final _wheelTypeController = TextEditingController();
  final _interiorTypeController = TextEditingController();
  final _exteriorConditionController = TextEditingController();
  final _steeringConditionController = TextEditingController();
  final _interiorConditionController = TextEditingController();
  final _specsController = TextEditingController();
  final _historyController = TextEditingController();
  final _wheelsController = TextEditingController();
  final _sellerPriceController = TextEditingController();
  final _minimumBidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFieldsIfEditing();
  }

  void _populateFieldsIfEditing() {
    final item = widget.item;
    if (item != null) {
      _titleController.text = item.title ?? '';
      _descriptionController.text = item.description ?? '';
      _modelController.text = item.model ?? '';
      _makeController.text = item.make ?? '';
      _yearController.text = item.year?.toString() ?? '';
      _mileageController.text = item.mileage?.toString() ?? '';
      _registeredInController.text = item.registeredIn ?? '';
      _bodyTypeController.text = item.bodyType ?? '';
      _engineSizeController.text = item.engineSize ?? '';
      _enteriorColorController.text = item.enteriorColor ?? '';
      _exteriorColorController.text = item.exteriorColor ?? '';
      _firstOwnerController.text = item.firstOwner ?? '';
      _fuelTypeController.text = item.fuelType ?? '';
      _safetyBeltController.text = item.safetyBeltStatus ?? '';
      _specificationController.text = item.specification ?? '';
      _transmissionController.text = item.transmission ?? '';
      _trimController.text = item.trim ?? '';
      _carOptionsController.text = item.carOptions ?? '';
      _keysController.text = item.keys?.toString() ?? '';
      _numberOfCylindersController.text =
          item.numberOfCylinders?.toString() ?? '';
      _wheelTypeController.text = item.wheelType ?? '';
      _interiorTypeController.text = item.interiorType ?? '';
      _exteriorConditionController.text = item.exteriorCondition ?? '';
      _steeringConditionController.text = item.steering ?? '';
      _interiorConditionController.text = item.interior ?? '';
      _specsController.text = item.specs ?? '';
      _historyController.text = item.history ?? '';
      _wheelsController.text = item.wheels ?? '';
      _sellerPriceController.text = item.sellerPrice?.toString() ?? '';
      _minimumBidController.text = item.minimumBid?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _modelController.dispose();
    _makeController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _registeredInController.dispose();
    _bodyTypeController.dispose();
    _engineSizeController.dispose();
    _enteriorColorController.dispose();
    _exteriorColorController.dispose();
    _firstOwnerController.dispose();
    _fuelTypeController.dispose();
    _safetyBeltController.dispose();
    _specificationController.dispose();
    _transmissionController.dispose();
    _trimController.dispose();
    _carOptionsController.dispose();
    _keysController.dispose();
    _numberOfCylindersController.dispose();
    _wheelTypeController.dispose();
    _interiorTypeController.dispose();
    _exteriorConditionController.dispose();
    _steeringConditionController.dispose();
    _interiorConditionController.dispose();
    _specsController.dispose();
    _historyController.dispose();
    _wheelsController.dispose();
    _sellerPriceController.dispose();
    _minimumBidController.dispose();
    super.dispose();
  }

  ItemModel _gatherItemModel() {
    return ItemModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      model: _modelController.text.trim(),
      make: _makeController.text.trim(),
      year: int.tryParse(_yearController.text.trim()),
      mileage: int.tryParse(_mileageController.text.trim()),
      registeredIn: _registeredInController.text.trim(),
      bodyType: _bodyTypeController.text.trim(),
      engineSize: _engineSizeController.text.trim(),
      enteriorColor: _enteriorColorController.text.trim(),
      exteriorColor: _exteriorColorController.text.trim(),
      firstOwner: _firstOwnerController.text.trim(),
      fuelType: _fuelTypeController.text.trim(),
      safetyBeltStatus: _safetyBeltController.text.trim(),
      specification: _specificationController.text.trim(),
      transmission: _transmissionController.text.trim(),
      trim: _trimController.text.trim(),
      carOptions: _carOptionsController.text.trim(),
      keys: int.tryParse(_keysController.text.trim()),
      numberOfCylinders: int.tryParse(_numberOfCylindersController.text.trim()),
      wheelType: _wheelTypeController.text.trim(),
      interiorType: _interiorTypeController.text.trim(),
      exteriorCondition: _exteriorConditionController.text.trim(),
      steering: _steeringConditionController.text.trim(),
      interior: _interiorConditionController.text.trim(),
      specs: _specsController.text.trim(),
      history: _historyController.text.trim(),
      wheels: _wheelsController.text.trim(),
      sellerPrice: double.tryParse(_sellerPriceController.text.trim()),
      minimumBid: double.tryParse(_minimumBidController.text.trim()),
    );
  }

  void _onSave(CarFormViewModel viewModel) {
    if (!_formKey.currentState!.validate()) {
      _showSnackbar('Please complete all required fields');
      return;
    }
    if (viewModel.selectedBidEndTime == null) {
      _showSnackbar('Please select an auction end time');
      return;
    }
    if (viewModel.newImages.isEmpty && viewModel.existingImageUrls.isEmpty) {
      _showSnackbar('Please upload at least one vehicle image');
      return;
    }

    ConfirmationDialog.show(
      context,
      title: 'Save Vehicle',
      message: 'Are you sure you want to add this vehicle to the auction system?',
      confirmText: 'Save',
      confirmColor: AppColors.primary,
      icon: Icons.save_rounded,
      onConfirm: () async {
        final payload = _gatherItemModel();
        final success = await viewModel.saveCar(payload);
        if (mounted) {
          if (success) {
            _showSnackbar('Vehicle added successfully', isError: false);
            _navigateBack();
          } else {
            _showSnackbar(viewModel.errorMessage ?? 'Failed to save vehicle');
          }
        }
      },
    );
  }

  void _onUpdate(CarFormViewModel viewModel) {
    if (!_formKey.currentState!.validate()) {
      _showSnackbar('Please complete all required fields');
      return;
    }

    ConfirmationDialog.show(
      context,
      title: 'Update Vehicle',
      message: 'Are you sure you want to save modifications to this vehicle?',
      confirmText: 'Update',
      confirmColor: AppColors.success,
      icon: Icons.edit_rounded,
      onConfirm: () async {
        final payload = _gatherItemModel();
        final success = await viewModel.updateCar(payload);
        if (mounted) {
          if (success) {
            _showSnackbar('Vehicle updated successfully', isError: false);
            _navigateBack();
          } else {
            _showSnackbar(viewModel.errorMessage ?? 'Failed to update vehicle');
          }
        }
      },
    );
  }

  void _onDelete(CarFormViewModel viewModel) {
    ConfirmationDialog.show(
      context,
      title: 'Delete Vehicle',
      message:
          'Are you sure you want to delete this vehicle? This action cannot be undone and will remove associated images.',
      confirmText: 'Delete',
      confirmColor: AppColors.error,
      icon: Icons.delete_forever_rounded,
      onConfirm: () async {
        final success = await viewModel.deleteCar();
        if (mounted) {
          if (success) {
            _showSnackbar('Vehicle deleted successfully', isError: false);
            _navigateBack();
          } else {
            _showSnackbar(viewModel.errorMessage ?? 'Failed to delete vehicle');
          }
        }
      },
    );
  }

  void _navigateBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationView()),
      );
    }
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
    final viewModel = context.watch<CarFormViewModel>();
    final isEditMode = viewModel.isEditMode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Vehicle' : 'Add New Vehicle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Media Section Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: CarImagePickerSection(
                    existingUrls: viewModel.existingImageUrls,
                    newImages: viewModel.newImages,
                    onPickImages: viewModel.pickImages,
                    onRemoveExisting: viewModel.removeExistingImage,
                    onRemoveNew: viewModel.removeNewImage,
                  ),
                ),
                const SizedBox(height: 16),

                // 2. General Information Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.info_outline_rounded,
                        title: 'General Information',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Vehicle Title',
                        hintText: 'e.g. 2022 Toyota Land Cruiser VX',
                        isRequired: true,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter vehicle title'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Detailed summary of the vehicle condition...',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _makeController,
                              labelText: 'Make',
                              hintText: 'e.g. Toyota',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _modelController,
                              labelText: 'Model',
                              hintText: 'e.g. Land Cruiser',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _yearController,
                              labelText: 'Year',
                              hintText: 'e.g. 2022',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _mileageController,
                              labelText: 'Mileage (km)',
                              hintText: 'e.g. 45000',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _registeredInController,
                        labelText: 'Registered City / State',
                        hintText: 'e.g. Islamabad',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Technical Specifications Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.engineering_outlined,
                        title: 'Technical Specifications',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _bodyTypeController,
                              labelText: 'Body Type',
                              hintText: 'e.g. SUV, Sedan',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _engineSizeController,
                              labelText: 'Engine Size',
                              hintText: 'e.g. 3.5L Turbo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _numberOfCylindersController,
                              labelText: 'Cylinders',
                              hintText: 'e.g. 6',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _fuelTypeController,
                              labelText: 'Fuel Type',
                              hintText: 'e.g. Petrol, Diesel, Hybrid',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _transmissionController,
                              labelText: 'Transmission',
                              hintText: 'e.g. Automatic, Manual',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _wheelTypeController,
                              labelText: 'Wheel Drive',
                              hintText: 'e.g. 4WD, AWD, FWD',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _keysController,
                              labelText: 'Number of Keys',
                              hintText: 'e.g. 2',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _wheelsController,
                              labelText: 'Wheels & Rims',
                              hintText: 'e.g. 18-inch Alloy',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _specificationController,
                        labelText: 'Regional Specs',
                        hintText: 'e.g. GCC Specs, Japanese Specs',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Colors, Trim & Interior Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.palette_outlined,
                        title: 'Styling & Interior',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _exteriorColorController,
                              labelText: 'Exterior Color',
                              hintText: 'e.g. Pearl White',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _enteriorColorController,
                              labelText: 'Interior Color',
                              hintText: 'e.g. Beige / Brown',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _trimController,
                              labelText: 'Trim Grade',
                              hintText: 'e.g. Signature, Limited',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _interiorTypeController,
                              labelText: 'Interior Material',
                              hintText: 'e.g. Leather, Fabric',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstOwnerController,
                              labelText: 'Ownership',
                              hintText: 'e.g. First Owner',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _safetyBeltController,
                              labelText: 'Safety Belt Status',
                              hintText: 'e.g. Intact / Original',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _carOptionsController,
                        labelText: 'Installed Car Options',
                        hintText: 'e.g. Sunroof, 360 Camera, Heads-up Display',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Conditions & Inspection Notes Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.fact_check_outlined,
                        title: 'Inspection & Condition Details',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _exteriorConditionController,
                        labelText: 'Exterior Condition',
                        hintText: 'Condition of body, paint, and panels...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _interiorConditionController,
                        labelText: 'Interior Condition',
                        hintText: 'Condition of seats, dashboard, and electronics...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _steeringConditionController,
                        labelText: 'Steering & Suspension',
                        hintText: 'Condition of steering, alignment, and shocks...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _historyController,
                        labelText: 'Service & Accident History',
                        hintText: 'Notable maintenance history, accident details...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _specsController,
                        labelText: 'Additional Notes & Specs',
                        hintText: 'Any extra features or warranty details...',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Bidding & Auction Settings
                CarBiddingSection(
                  sellerPriceController: _sellerPriceController,
                  minimumBidController: _minimumBidController,
                  isActive: viewModel.isActive,
                  onActiveChanged: viewModel.setIsActive,
                  bidEndTime: viewModel.selectedBidEndTime,
                  onBidEndTimeSelected: viewModel.setSelectedBidEndTime,
                ),
                const SizedBox(height: 24),

                // 7. Action Buttons
                if (!isEditMode) ...[
                  CustomButton(
                    label: 'Save Vehicle',
                    onPressed: viewModel.isBusy ? null : () => _onSave(viewModel),
                    isLoading: viewModel.isSaving,
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  ),
                ] else ...[
                  CustomButton(
                    label: 'Update Vehicle',
                    onPressed: viewModel.isBusy ? null : () => _onUpdate(viewModel),
                    isLoading: viewModel.isUpdating,
                    variant: CustomButtonVariant.success,
                    icon: const Icon(Icons.check_rounded, size: 20),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    label: 'Delete Vehicle',
                    onPressed: viewModel.isBusy ? null : () => _onDelete(viewModel),
                    isLoading: viewModel.isDeleting,
                    variant: CustomButtonVariant.danger,
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
