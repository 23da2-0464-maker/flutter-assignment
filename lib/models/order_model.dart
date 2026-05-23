import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final double total;
  final String address;
  final String phone;
  final List<dynamic> items;
  final DateTime date;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.total,
    required this.address,
    required this.phone,
    required this.items,
    required this.date,
    this.status = 'Pending',
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    
    return OrderModel(
      id: doc.id,
      userId: data?['userId'] ?? '',
      total: (data?['total'] as num? ?? 0.0).toDouble(), 
      address: data?['address'] ?? '',
      phone: data?['phone'] ?? '',
      items: data?['items'] as List<dynamic>? ?? [],
      date: (data?['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data?['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': id,
      'userId': userId,
      'total': total,
      'address': address,
      'phone': phone,
      'items': items,
      'date': Timestamp.fromDate(date),
      'status': status,
    };
  }
}