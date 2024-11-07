import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/auth_provider.dart';
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
      final authState = ref.read(authNotifierProvider);
      final api = ref.read(wooCommerceAPIProvider);

      // Check if the user is authenticated (user is not null)
      if (authState.user != null) {
        final user = authState.user!; // Access the user object

        // Create user details (including address, city, postcode, country, state, phone)
        final userDetails = {
          'customer_id': int.parse(user.id), // Ensure customer_id is an integer
          'billing': {
            'email': user.email, // Using email and username
            'username': user.userDisplayName,
            'first_name': user.firstName,
            'last_name': user.lastName,
            'address_1': user.address, // Billing address line 1
            'address_2': '', // Optional, can be left empty or add if available
            'city': user.city,
            'postcode': user.postcode,
            'country': user.country,
            'phone': user.phoneNumber, // Billing phone number
          },
          'shipping': {
            'email': user.email, // Same details for shipping
            'username': user.userDisplayName,
            'first_name': user.firstName,
            'last_name': user.lastName,
            'address_1': user.address, // Shipping address line 1
            'address_2': '', // Optional, can be left empty or add if available
            'city': user.city,
            'postcode': user.postcode,
            'country': user.country,
            'phone': user.phoneNumber, // Shipping phone number
          },
        };

        // Create the order by passing the cart items and user details
        final response = await api.createOrder(state, userDetails);

        if (response.isNotEmpty && response['id'] != null) {
          // Clear the cart after successful order
          state = [];
        }

        print('Order placed successfully: ${response['id']}');
      } else {
        print('No authenticated user found.');
      }
    } catch (e) {
      print('Failed to place order: $e');
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier(ref);
});
