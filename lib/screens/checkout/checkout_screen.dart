import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart'; // Import this to get the User ID

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('CHECKOUT', style: AppTextStyles.h4.copyWith(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          children: [
            Text('SHIPPING ADDRESS', style: AppTextStyles.h4),
            const SizedBox(height: 24),
            _buildTextField('Street Address', _addressController),
            const SizedBox(height: 16),
            _buildTextField('City', _cityController),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
            
            const SizedBox(height: 40),
            Text('ORDER SUMMARY', style: AppTextStyles.h4),
            const Divider(height: 32),
            
            _buildSummaryRow('Subtotal', '\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
            _buildSummaryRow('Shipping', 'FREE'),
            const Divider(height: 32),
            _buildSummaryRow('Total', '\$${cartProvider.totalAmount.toStringAsFixed(2)}', isTotal: true),
            
            const SizedBox(height: 40),
            CustomButton(
              text: 'PLACE ORDER',
              onPressed: () => _handlePlaceOrder(cartProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Field required' : null,
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? AppTextStyles.h3 : AppTextStyles.bodyMedium),
          Text(value, style: isTotal ? AppTextStyles.h3 : AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  // --- UPDATED STEP 3 LOGIC ---
  void _handlePlaceOrder(CartProvider cart) async {
    if (_formKey.currentState!.validate()) {
      // 1. Get the current user ID
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found. Please log in again.')),
        );
        return;
      }

      try {
        // 2. Show a loading spinner so the user knows something is happening
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        // 3. Save to Firestore via the method we added to CartProvider
        await cart.placeOrder(
          userId: userId,
          address: '${_addressController.text}, ${_cityController.text}',
          phone: _phoneController.text,
        );

        // 4. If successful, close the loading spinner and show success dialog
        if (mounted) {
          Navigator.pop(context); // Close loading
          _showSuccessDialog();
        }
      } catch (e) {
        // Handle any database errors
        if (mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text('Your order has been saved successfully in our system.'),
        actions: [
          TextButton(
            onPressed: () => context.go('/'), // Go back home
            child: const Text('CONTINUE SHOPPING'),
          ),
        ],
      ),
    );
  }
}