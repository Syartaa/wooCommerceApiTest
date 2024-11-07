import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woo_commerce_test/provider/product_provider.dart';

class CategoryProductsPage extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  CategoryProductsPage({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch products for the selected category
    final productsAsyncValue = ref.watch(productProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: productsAsyncValue.when(
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl =
                  (product['images'] != null && product['images'].isNotEmpty)
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
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
