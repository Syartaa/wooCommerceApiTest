import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/woo_provider.dart';

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;
  CartNotifier(this.ref) : super([]);

  void addProduct(Map<String, dynamic> product) {
    //check if product is in cart
    final index = state.indexWhere((item) => item['id'] == product['id']);

    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            {...state[i], 'quantity': state[i]['quantity'] + 1}
          else
            state[i]
      ];
    } else {
      // If product not in cart, add with quantity 1
      state = [
        ...state,
        {...product, 'quantity': 1}
      ];
    }
  }

  void removeProduct(Map<String, dynamic> product) {
    state = state.where((item) => item['id'] != product['id']).toList();
  }

  // Get total price
  double getTotalPrice() {
    return state.fold(0.0, (total, item) {
      final price = double.tryParse(item['price'].toString()) ?? 0.0;
      final quantity = item['quantity'] as int;
      return total + price * quantity;
    });
  }

//place an order

  Future<void> placeOrder() async {
    try {
      final api = ref.read(wooCommerceAPIProvider);
      final response = await api.createOrder(state);
      // Check if the response is successful and clear the cart
      if (response.isNotEmpty && response['id'] != null) {
        state = []; // Clear the cart
      }
      print('Order placed successfully: ${response['id']}');
    } catch (e) {
      print('Failed to place order: $e');
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier(ref);
});
