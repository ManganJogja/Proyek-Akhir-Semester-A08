import 'package:flutter/material.dart';
import '../models/wishlist_entry.dart';

class WishlistProvider with ChangeNotifier {
  List<WishlistEntry> _wishlist = [];

  List<WishlistEntry> get wishlist => _wishlist;

  void addToWishlist(WishlistEntry entry) {
    _wishlist.add(entry);
    notifyListeners();
  }

  void removeFromWishlist(WishlistEntry entry) {
    _wishlist.remove(entry);
    notifyListeners();
  }

  bool isInWishlist(WishlistEntry entry) {
    return _wishlist.contains(entry);
  }
}