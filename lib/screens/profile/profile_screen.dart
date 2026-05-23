import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/routes/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE', style: AppTextStyles.h4.copyWith(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accent,
            child: Icon(Icons.person, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Fashion Enthusiast', 
            style: AppTextStyles.h3
          ),
          Text(
            user?.email ?? 'No email found', 
            style: AppTextStyles.bodySmall
          ),
          const SizedBox(height: 32),
          
          _buildProfileTile(
            Icons.shopping_bag_outlined, 
            'My Orders', 
            onTap: () => context.push(AppRouter.orderHistory),
          ),
          
          _buildProfileTile(
            Icons.favorite_border, 
            'Wishlist',
            onTap: () => context.push(AppRouter.wishlist),
          ),
          _buildProfileTile(
            Icons.location_on_outlined, 
            'Shipping Address',
            onTap: () => context.push(AppRouter.shippingAddress),
          ),
          _buildProfileTile(
            Icons.settings_outlined, 
            'Settings',
            onTap: () => context.push(AppRouter.settings),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: TextButton(
              onPressed: () async {
                context.read<CartProvider>().resetCart();
                await context.read<AuthProvider>().signOut();
              },
              child: const Text(
                'LOGOUT', 
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}