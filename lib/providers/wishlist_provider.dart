import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistProductIds = {};
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Set<String> get wishlistIds => _wishlistProductIds;

  bool isFavorite(String productId) => _wishlistProductIds.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }
}