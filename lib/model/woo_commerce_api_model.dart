// woo_commerce_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WooCommerceAPI {
  final String baseUrl;
  final String consumerKey;
  final String consumerSecret;

  WooCommerceAPI({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
  });

  Future<List<dynamic>> getProducts() async {
    final String url =
        '$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> getCategories() async {
    final String url =
        '$baseUrl/wp-json/wc/v3/products/categories?consumer_key=$consumerKey&consumer_secret=$consumerSecret';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<dynamic>> getProductsByCategory(String categoryId) async {
    // Fetch products by category ID
    final response = await http.get(Uri.parse(
        'https://your-woocommerce-site.com/wp-json/wc/v3/products?category=$categoryId&consumer_key=your_key&consumer_secret=your_secret'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
