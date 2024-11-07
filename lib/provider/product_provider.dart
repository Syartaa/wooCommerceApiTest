import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/woo_provider.dart';

final productProvider = FutureProvider<List<dynamic>>((ref) async {
  // Get the WooCommerceAPI instance
  final api = ref.watch(wooCommerceAPIProvider);

  // Fetch the products from the API
  return await api.getProducts();
});
