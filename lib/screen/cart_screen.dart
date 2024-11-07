import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.read(cartProvider.notifier).getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final imageUrl = (item['images'] != null && item['images'].isNotEmpty)
              ? item['images'][0]['src']
              : null;
          return ListTile(
            leading: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image_not_supported),
            title: Text(item['name']),
            subtitle: Text("\$${item['price']} x ${item['quantity']}"),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                ref.read(cartProvider.notifier).removeProduct(item);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(cartProvider.notifier).placeOrder();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully!')),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
