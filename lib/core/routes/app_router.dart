import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/products/product_detail_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/order_history_screen.dart';
import '../../screens/profile/wishlist_screen.dart';
import '../../screens/profile/shipping_address_screen.dart';
import '../../screens/profile/settings_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String orderHistory = '/order-history';
  static const String wishlist = '/wishlist';
  static const String shippingAddress = '/shipping-address';
  static const String settings = '/settings';

  static GoRouter router(AuthProvider authProvider) => GoRouter(
    initialLocation: login,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final bool loggedIn = authProvider.user != null;
      final bool isAuthPage = state.matchedLocation == login || state.matchedLocation == register;

      if (!loggedIn && !isAuthPage) return login;
      if (loggedIn && isAuthPage) return home;
      return null;
    },
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(path: cart, builder: (context, state) => const CartScreen()),
      GoRoute(path: checkout, builder: (context, state) => const CheckoutScreen()),
      GoRoute(path: profile, builder: (context, state) => const ProfileScreen()),
      GoRoute(path: orderHistory, builder: (context, state) => const OrderHistoryScreen()),
      GoRoute(path: wishlist, builder: (context, state) => const WishlistScreen()),
      GoRoute(path: shippingAddress, builder: (context, state) => const ShippingAddressScreen()),
      GoRoute(path: settings, builder: (context, state) => const SettingsScreen()),
    ],
  );
}