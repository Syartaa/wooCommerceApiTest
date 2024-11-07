import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/woo_provider.dart';

final productProvider =
    FutureProvider.family<List<dynamic>, String>((ref, categoryId) async {
  final api = ref.watch(wooCommerceAPIProvider);
  return await api.getProductsByCategory(
      categoryId); // Replace with actual API call to fetch products by category ID
});
