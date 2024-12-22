import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wishlist_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';

class WishlistProvider extends ChangeNotifier {
  List<Wishlist> _wishlist = [];
  List<Wishlist> get wishlist => _wishlist;
  
  Future<void> fetchWishlist(CookieRequest request) async {
    try {
      final response = await request.get('http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/wishlist/json/');
      
      
      if (response is List) {
        _wishlist = wishlistFromJson(jsonEncode(response));
        notifyListeners();
      } else {
        print('Error: Invalid response format');
        _wishlist = [];
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      _wishlist = [];
      notifyListeners();
    }
  }

  Future<bool> toggleWishlist(CookieRequest request, String restaurantId) async {
    try {
      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/wishlist/toggle/$restaurantId/',
        {},
      );
      
      if (response is Map && response.containsKey('added')) {
        await fetchWishlist(request);
        return response['added'] as bool;
      }
      return false;
    } catch (e) {
      print('Error toggling wishlist: $e');
      return false;
    }
  }

  Future<bool> addWishlistWithPlan(CookieRequest request, String restaurantId, DateTime datePlan, String additionalNote) async {
    try {
      // Debug print untuk melihat data yang dikirim
      print('Sending data:');
      print('Restaurant ID: $restaurantId');
      print('Date Plan: ${datePlan.toIso8601String()}');
      print('Additional Note: $additionalNote');

      // Kirim data sesuai dengan format yang diharapkan oleh Django WishlistForm
      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/wishlist/add/$restaurantId/',
        {
          'date_plan': DateFormat('yyyy-MM-dd').format(datePlan), // Format tanggal sesuai dengan Django
          'additional_note': additionalNote,
        },
      );
      
      // Debug print untuk melihat response
      print('Response received:');
      print(response);

      // Periksa response sesuai dengan format Django
      if (response is Map) {
        if (response['success'] == true) {
          // Refresh wishlist setelah berhasil menambahkan plan
          await fetchWishlist(request);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error adding wishlist plan: $e');
      return false;
    }
  }

  Future<bool> editWishlistPlan(
    CookieRequest request,
    String restaurantId,
    DateTime datePlan,
    String additionalNote,
  ) async {
    try {
      print('Sending edit data:');
      print('Restaurant ID: $restaurantId');
      print('Date Plan: ${datePlan.toIso8601String()}');
      print('Additional Note: $additionalNote');

      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/wishlist/edit/$restaurantId/',
        {
          'date_plan': DateFormat('yyyy-MM-dd').format(datePlan),
          'additional_note': additionalNote,
        },
      );
      
      print('Edit response received:');
      print(response);

      if (response is Map && response['success'] == true) {
        await fetchWishlist(request);
        return true;
      }
      return false;
    } catch (e) {
      print('Error editing wishlist plan: $e');
      return false;
    }
  }

  Future<bool> deleteWishlist(CookieRequest request, String restaurantId) async {
    try {
      print('Deleting wishlist item:');
      print('Restaurant ID: $restaurantId');

      final response = await request.post(
        'http://raysha-reifika-manganjogja.pbp.cs.ui.ac.id/wishlist/delete/$restaurantId/',
        {},
      );
      
      print('Delete response received:');
      print(response);

      if (response is Map && response['success'] == true) {
        await fetchWishlist(request);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting wishlist item: $e');
      return false;
    }
  }
}