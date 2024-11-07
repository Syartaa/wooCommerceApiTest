import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/cart_provider.dart';
import 'package:woo_commerce_test/provider/categories_provider.dart';
import 'package:woo_commerce_test/provider/product_provider.dart';
import 'package:woo_commerce_test/screen/cart_screen.dart';

class ProductTest extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoryProvider);
    final productsAsyncValue = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: Column(
        children: [
          // Categories slider
          categoriesAsyncValue.when(
            data: (categories) {
              return Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final imageUrl = category['image']?['src'] ?? '';

                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(Icons.category, size: 40),
                        ),
                        SizedBox(height: 4),
                        // Wrapping the Text widget in an expanded container
                        Container(
                          width: 70, // Limit the width for the category text
                          child: Text(
                            category['name'],
                            style: TextStyle(fontSize: 12),
                            maxLines: 2, // Allow two lines
                            overflow:
                                TextOverflow.ellipsis, // Ellipsis for long text
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),

          // Divider between categories and products
          Divider(),

          // Products list
          Expanded(
            child: productsAsyncValue.when(
              data: (products) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = (product['images'] != null &&
                            product['images'].isNotEmpty)
                        ? product['images'][0]['src']
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
                      title: Text(product['name']),
                      subtitle: Text("\$${product['price']}"),
                      trailing: IconButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addProduct(product);
                          },
                          icon: Icon(Icons.add_shopping_cart)),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
