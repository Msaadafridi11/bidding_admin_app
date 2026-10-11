import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class DealerService {
  final FirebaseFirestore _firestore;

  DealerService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.firestoreUsersCollection);

  /// Realtime stream of dealers from userModel collection.
  Stream<List<UserModel>> getDealersStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data(), docId: doc.id);
      }).toList();
    });
  }

  /// Approves a dealer by setting isVerified = true.
  Future<void> approveDealer(String uid) async {
    try {
      await _collection.doc(uid).update({'isVerified': true});
    } catch (e) {
      debugPrint('DealerService.approveDealer error: $e');
      throw Exception('Failed to approve dealer: $e');
    }
  }

  /// Rejects a dealer by deleting the user document.
  Future<void> rejectDealer(String uid) async {
    try {
      await _collection.doc(uid).delete();
    } catch (e) {
      debugPrint('DealerService.rejectDealer error: $e');
      throw Exception('Failed to reject dealer: $e');
    }
  }
}
