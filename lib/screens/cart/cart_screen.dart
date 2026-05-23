import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/common/custom_button.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.watch so the UI rebuilds whenever notifyListeners() is called in the provider
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('MY BAG', style: AppTextStyles.h4.copyWith(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Container(
                            width: 100,
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(item.product.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(item.product.name, style: AppTextStyles.h4),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () => cartProvider.removeItem(index),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Size: ${item.selectedSize ?? "N/A"} | Color: ${item.selectedColor ?? "N/A"}',
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item.product.price.toStringAsFixed(2)}',
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    // Quantity Selector
                                    Row(
                                      children: [
                                        _quantityButton(Icons.remove, () {
                                          cartProvider.decrementQuantity(index);
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text('${item.quantity}', style: AppTextStyles.bodyMedium),
                                        ),
                                        _quantityButton(Icons.add, () {
                                          cartProvider.incrementQuantity(index);
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildSummary(context, cartProvider),
              ],
            ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.border),
          const SizedBox(height: 16),
          Text('Your bag is empty', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.go(AppRouter.home),
            child: const Text('START SHOPPING'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.h3),
                Text(
                  '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'PROCEED TO CHECKOUT',
              onPressed: () => context.push(AppRouter.checkout),
            ),
          ],
        ),
      ),
    );
  }
}