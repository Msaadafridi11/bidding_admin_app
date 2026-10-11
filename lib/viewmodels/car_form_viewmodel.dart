import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item_model.dart';
import '../services/car_service.dart';

class CarFormViewModel extends ChangeNotifier {
  final CarService _carService;
  final ItemModel? item;

  CarFormViewModel({
    CarService? carService,
    this.item,
  }) : _carService = carService ?? CarService() {
    _initFromItem();
  }

  bool _isSaving = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _errorMessage;
  String? _successMessage;

  final List<File> _newImages = [];
  final List<String> _existingImageUrls = [];

  bool _isActive = true;
  DateTime? _selectedBidEndTime;

  bool get isSaving => _isSaving;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get isBusy => _isSaving || _isUpdating || _isDeleting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  List<File> get newImages => List.unmodifiable(_newImages);
  List<String> get existingImageUrls => List.unmodifiable(_existingImageUrls);

  bool get isActive => _isActive;
  DateTime? get selectedBidEndTime => _selectedBidEndTime;
  bool get isEditMode => item != null && item!.itemId != null;

  void _initFromItem() {
    if (item != null) {
      if (item!.imageUrls != null) {
        _existingImageUrls.addAll(item!.imageUrls!);
      }
      _isActive = item!.isActive ?? true;
      _selectedBidEndTime = item!.bidEndTime;
    }
  }

  void setIsActive(bool value) {
    _isActive = value;
    notifyListeners();
  }

  void setSelectedBidEndTime(DateTime? dateTime) {
    _selectedBidEndTime = dateTime;
    notifyListeners();
  }

  Future<void> pickImages() async {
    try {
      final picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        _newImages.addAll(images.map((x) => File(x.path)));
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick images: $e';
      notifyListeners();
    }
  }

  void removeExistingImage(String url) {
    _existingImageUrls.remove(url);
    notifyListeners();
  }

  void removeNewImage(File file) {
    _newImages.remove(file);
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Saves a new car
  Future<bool> saveCar(ItemModel car) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      car.isActive = _isActive;
      car.bidEndTime = _selectedBidEndTime;

      await _carService.addCar(
        car: car,
        images: _newImages,
      );

      _isSaving = false;
      _successMessage = 'Car added successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Updates existing car
  Future<bool> updateCar(ItemModel updatedFields) async {
    if (item == null || item!.itemId == null) {
      _errorMessage = 'Invalid car ID for update';
      notifyListeners();
      return false;
    }

    _isUpdating = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      updatedFields.itemId = item!.itemId;
      updatedFields.isActive = _isActive;
      updatedFields.bidEndTime = _selectedBidEndTime;

      await _carService.updateCar(
        car: updatedFields,
        newImages: _newImages,
        existingImageUrls: _existingImageUrls,
      );

      _newImages.clear();
      _isUpdating = false;
      _successMessage = 'Car updated successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isUpdating = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Deletes existing car
  Future<bool> deleteCar() async {
    if (item == null || item!.itemId == null) {
      _errorMessage = 'Invalid car ID for deletion';
      notifyListeners();
      return false;
    }

    _isDeleting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _carService.deleteCar(
        itemId: item!.itemId!,
        imageUrls: item!.imageUrls ?? [],
      );

      _isDeleting = false;
      _successMessage = 'Car deleted successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isDeleting = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
