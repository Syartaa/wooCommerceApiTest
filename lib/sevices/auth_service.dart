import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final Dio _dio = Dio();

  String get _baseUrl => dotenv.env['WOO_COMMERCE_BASE_URL'] ?? '';
  String get _consumerKey => dotenv.env['WOO_COMMERCE_CONSUMER_KEY'] ?? '';
  String get _consumerSecret =>
      dotenv.env['WOO_COMMERCE_CONSUMER_SECRET'] ?? '';

  String get _basicAuth {
    final credentials = '$_consumerKey:$_consumerSecret';
    return 'Basic ${base64Encode(utf8.encode(credentials))}';
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await _dio.post(
      '$_baseUrl/wp-json/jwt-auth/v1/token',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<Map<String, dynamic>?> signup(
      String email, String username, String password) async {
    final response = await _dio.post('$_baseUrl/wp-json/wc/v3/customers',
        data: {
          'email': email,
          'username': username,
          'password': password,
        },
        options: Options(headers: {
          'Authorization': _basicAuth,
        }));
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to sign up');
    }
  }
}
