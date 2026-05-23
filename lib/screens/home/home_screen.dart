import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/common/product_card.dart';
import '../../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['All', 'Men', 'Women', 'Accessories', 'Shoes'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final filteredItems = productProvider.filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- RESTORED HEADER WITH PROFILE AND CART ---
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person_outline, color: AppColors.primary),
                            onPressed: () => context.push(AppRouter.profile),
                          ),
                          Column(
                            children: [
                              Text('Fashion Store', style: AppTextStyles.h3),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                            onPressed: () => context.push(AppRouter.cart),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        onChanged: (value) => productProvider.setSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.border),
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),

                    // Categories List
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final isSelected = productProvider.selectedCategory == categories[index];
                          return GestureDetector(
                            onTap: () => productProvider.setCategory(categories[index]),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Product Display Area
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        productProvider.selectedCategory == 'All' 
                            ? 'All Products' 
                            : productProvider.selectedCategory,
                        style: AppTextStyles.h3,
                      ),
                    ),
                    
                    filteredItems.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text("No products found"),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return ProductCard(product: filteredItems[index]);
                              },
                            ),
                          ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}