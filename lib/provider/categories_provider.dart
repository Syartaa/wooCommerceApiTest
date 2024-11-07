import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/woo_provider.dart';

final categoryProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(wooCommerceAPIProvider);
  return await api.getCategories();
});
