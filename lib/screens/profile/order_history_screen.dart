import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Start fetching orders as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<CartProvider>(context, listen: false).fetchUserOrders(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('MY ORDERS', style: AppTextStyles.h4.copyWith(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: cartProvider.orderHistory.isEmpty
          ? const Center(child: Text("No orders found yet."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.orderHistory.length,
              itemBuilder: (context, index) {
                final order = cartProvider.orderHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text('Order ID: ${order.id.substring(0, 8)}...', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${order.items.length} Items'),
                        Text(order.date.toString().split(' ')[0]), // Shows YYYY-MM-DD
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${order.total.toStringAsFixed(2)}', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(order.status, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}