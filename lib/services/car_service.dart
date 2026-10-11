import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/item_model.dart';
import 'storage_service.dart';

class CarService {
  final FirebaseFirestore _firestore;
  final StorageService _storageService;

  CarService({
    FirebaseFirestore? firestore,
    StorageService? storageService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storageService = storageService ?? StorageService();

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.firestoreItemsCollection);

  /// Realtime stream of cars from Firestore.
  Stream<List<ItemModel>> getCarsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ItemModel.fromMap(data, docId: doc.id);
      }).toList();
    });
  }

  /// Adds a new car, uploading images first and then writing to Firestore.
  Future<void> addCar({
    required ItemModel car,
    required List<File> images,
  }) async {
    try {
      final docRef = _collection.doc();
      final itemId = docRef.id;

      // 1. Upload images
      List<String> uploadedUrls = [];
      if (images.isNotEmpty) {
        uploadedUrls = await _storageService.uploadMultipleImages(images);
      }

      // 2. Prepare payload
      car.itemId = itemId;
      car.imageUrls = uploadedUrls;
      car.createdAt = DateTime.now();

      // 3. Save to Firestore
      await docRef.set(car.toMap());
    } catch (e) {
      debugPrint('CarService.addCar error: $e');
      throw Exception('Failed to save car: $e');
    }
  }

  /// Updates an existing car document.
  Future<void> updateCar({
    required ItemModel car,
    required List<File> newImages,
    required List<String> existingImageUrls,
  }) async {
    if (car.itemId == null || car.itemId!.isEmpty) {
      throw Exception('Car item ID is required for update');
    }

    try {
      final List<String> finalUrls = List.from(existingImageUrls);

      // 1. Upload new images
      if (newImages.isNotEmpty) {
        final newUrls = await _storageService.uploadMultipleImages(newImages);
        finalUrls.addAll(newUrls);
      }

      car.imageUrls = finalUrls;

      // 2. Update Firestore document
      await _collection.doc(car.itemId).update(car.toMap());
    } catch (e) {
      debugPrint('CarService.updateCar error: $e');
      throw Exception('Failed to update car: $e');
    }
  }

  /// Deletes a car and its associated Supabase storage images.
  Future<void> deleteCar({
    required String itemId,
    required List<String> imageUrls,
  }) async {
    try {
      // 1. Delete images from Supabase storage
      if (imageUrls.isNotEmpty) {
        await _storageService.deleteImagesByUrls(imageUrls);
      }

      // 2. Delete Firestore document
      await _collection.doc(itemId).delete();
    } catch (e) {
      debugPrint('CarService.deleteCar error: $e');
      throw Exception('Failed to delete car: $e');
    }
  }
}
