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
      final response = await request.get('http://127.0.0.1:8000/wishlist/json/');
      print('Fetch response:');
      print(response);
      
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
        'http://127.0.0.1:8000/wishlist/toggle/$restaurantId/',
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
        'http://127.0.0.1:8000/wishlist/add/$restaurantId/',
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
}