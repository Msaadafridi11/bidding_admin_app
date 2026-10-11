import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/car_service.dart';

enum CarFilterStatus { all, active, inactive }

class CarListViewModel extends ChangeNotifier {
  final CarService _carService;
  StreamSubscription<List<ItemModel>>? _subscription;

  CarListViewModel({CarService? carService})
      : _carService = carService ?? CarService() {
    _initCarStream();
  }

  List<ItemModel> _allCars = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  CarFilterStatus _filterStatus = CarFilterStatus.all;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  CarFilterStatus get filterStatus => _filterStatus;

  List<ItemModel> get cars {
    return _allCars.where((car) {
      // Status filter
      if (_filterStatus == CarFilterStatus.active && car.isActive != true) {
        return false;
      }
      if (_filterStatus == CarFilterStatus.inactive && car.isActive == true) {
        return false;
      }

      // Search query filter
      if (_searchQuery.trim().isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final title = (car.title ?? '').toLowerCase();
      final make = (car.make ?? '').toLowerCase();
      final model = (car.model ?? '').toLowerCase();
      return title.contains(query) || make.contains(query) || model.contains(query);
    }).toList();
  }

  int get totalCount => _allCars.length;
  int get activeCount => _allCars.where((c) => c.isActive == true).length;
  int get inactiveCount => _allCars.where((c) => c.isActive != true).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(CarFilterStatus status) {
    _filterStatus = status;
    notifyListeners();
  }

  void _initCarStream() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _carService.getCarsStream().listen(
      (carList) {
        _allCars = carList;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      },
    );
  }

  void refresh() {
    _initCarStream();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
