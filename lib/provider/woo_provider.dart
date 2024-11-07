import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woo_commerce_test/model/woo_commerce_api_model.dart';

final wooCommerceAPIProvider = Provider<WooCommerceAPI>((ref) {
  final baseUrl = dotenv.env['WOO_COMMERCE_BASE_URL']!;
  final consumerKey = dotenv.env['WOO_COMMERCE_CONSUMER_KEY']!;
  final consumerSecret = dotenv.env['WOO_COMMERCE_CONSUMER_SECRET']!;

  return WooCommerceAPI(
    baseUrl: baseUrl,
    consumerKey: consumerKey,
    consumerSecret: consumerSecret,
  );
});
