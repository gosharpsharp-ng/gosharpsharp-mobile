import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// Utility class for handling base64 image conversions
class Base64ImageUtils {
  /// Convert image file to base64 string with proper data URI format
  static Future<String> convertImageToBase64(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);

    // Get file extension to determine MIME type
    String extension = path.extension(imagePath).toLowerCase();
    String mimeType = _getMimeType(extension);

    // Return proper data URI format
    return 'data:$mimeType;base64,$base64String';
  }

  /// Helper function to determine MIME type from file extension
  static String _getMimeType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      case '.svg':
        return 'image/svg+xml';
      default:
        return 'image/jpeg'; // Default to JPEG if unknown
    }
  }

  /// Convert base64 string to MemoryImage (handles both formats)
  static MemoryImage base64ToMemoryImage(String base64String) {
    String cleanBase64;

    // Check if it's already in data URI format
    if (base64String.startsWith('data:')) {
      // Extract just the base64 part after the comma
      cleanBase64 = base64String.split(',').last;
    } else {
      // It's just base64, use as is
      cleanBase64 = base64String;
    }

    // Remove any whitespace
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s'), '');

    Uint8List bytes = base64Decode(cleanBase64);
    return MemoryImage(bytes);
  }

  /// Add data URI prefix to existing base64 string
  static String addDataUriPrefix(String base64String, {String mimeType = 'image/jpeg'}) {
    if (base64String.startsWith('data:')) {
      return base64String; // Already has prefix
    }
    return 'data:$mimeType;base64,$base64String';
  }

  /// Extract just the base64 part from data URI
  static String extractBase64FromDataUri(String dataUri) {
    if (dataUri.startsWith('data:')) {
      return dataUri.split(',').last;
    }
    return dataUri; // Already just base64
  }

  /// Check if string is a valid base64 format
  static bool isValidBase64(String base64String) {
    try {
      String cleanBase64 = extractBase64FromDataUri(base64String);
      base64Decode(cleanBase64);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get image widget from base64 string
  static Widget base64ToImageWidget(
    String base64String, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    try {
      return Image.memory(
        base64ToMemoryImage(base64String).bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
        },
      );
    } catch (e) {
      return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
    }
  }
}