import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product, {String? size, String? color}) {
    final existingIndex = _items.indexWhere((item) => 
      item.product.id == product.id && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index); 
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void resetCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);
  int get itemCount => _items.length;

  Future<void> placeOrder({
    required String userId,
    required String address,
    required String phone,
  }) async {
    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      
      final orderData = {
        'orderId': orderRef.id,
        'userId': userId,
        'address': address,
        'phone': phone,
        'total': totalAmount,
        'date': FieldValue.serverTimestamp(),
        'items': _items.map((item) => {
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'size': item.selectedSize,
        }).toList(),
      };

      await orderRef.set(orderData);
      
      resetCart(); 
    } catch (e) {
      debugPrint("Error placing order: $e");
      rethrow;
    }
  }

  List<OrderModel> _orderHistory = [];
  List<OrderModel> get orderHistory => _orderHistory;

  Future<void> fetchUserOrders(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      _orderHistory = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      
      if (e.toString().contains('index')) {
        final simpleSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();
            
        _orderHistory = simpleSnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
        notifyListeners();
      }
    }
  }
}