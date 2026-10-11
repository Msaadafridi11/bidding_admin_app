import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  final SupabaseClient _supabase;

  StorageService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Uploads a single image file to Supabase storage and returns the public URL.
  Future<String> uploadImage(File file) async {
    try {
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_${file.path.split('/').last.split('\\').last}';
      final path = '${AppConstants.supabaseUploadsFolder}/$fileName';

      await _supabase.storage
          .from(AppConstants.supabaseImagesBucket)
          .upload(path, file);

      final publicUrl = _supabase.storage
          .from(AppConstants.supabaseImagesBucket)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint('StorageService.uploadImage error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Uploads multiple image files to Supabase storage.
  Future<List<String>> uploadMultipleImages(List<File> files) async {
    final List<String> urls = [];
    for (int i = 0; i < files.length; i++) {
      try {
        final fileName =
            '${DateTime.now().microsecondsSinceEpoch}_$i.jpg';
        final path = '${AppConstants.supabaseUploadsFolder}/$fileName';

        await _supabase.storage
            .from(AppConstants.supabaseImagesBucket)
            .upload(path, files[i]);

        final url = _supabase.storage
            .from(AppConstants.supabaseImagesBucket)
            .getPublicUrl(path);

        urls.add(url);
      } catch (e) {
        debugPrint('StorageService.uploadMultipleImages error on file $i: $e');
        throw Exception('Failed to upload images: $e');
      }
    }
    return urls;
  }

  /// Deletes images given their public URLs.
  Future<void> deleteImagesByUrls(List<String> imageUrls) async {
    if (imageUrls.isEmpty) return;
    try {
      final paths = imageUrls
          .map((url) => getSupabasePathFromUrl(url))
          .where((p) => p.isNotEmpty)
          .toList();

      if (paths.isNotEmpty) {
        await _supabase.storage
            .from(AppConstants.supabaseImagesBucket)
            .remove(paths);
      }
    } catch (e) {
      debugPrint('StorageService.deleteImagesByUrls error: $e');
      // Do not rethrow if image delete fails so document deletion can proceed
    }
  }

  /// Helper to extract Supabase storage path from a public URL.
  String getSupabasePathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.pathSegments
          .skipWhile((segment) => segment != AppConstants.supabaseUploadsFolder)
          .join('/');
    } catch (e) {
      return '';
    }
  }
}
