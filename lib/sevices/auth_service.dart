import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:woo_commerce_test/model/user.dart';

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

  Future<User?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/wp-json/jwt-auth/v1/token',
        data: {
          'username': username,
          'password': password,
        },
      );

      // Debugging: Log the full response to see its structure
      print('Login Response: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userEmail = response
            .data['user_email']; // You can use user_email or other user details

        // Fetch user details using user_email (or another identifier if needed)
        final user = await _getUserDetailsByEmail(userEmail);

        if (user != null) {
          return user;
        } else {
          throw Exception('Failed to fetch user details');
        }
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<User?> signup(String email, String username, String password) async {
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

  Future<User?> _getUserDetailsByEmail(String email) async {
    final response = await _dio.get('$_baseUrl/wp-json/wc/v3/customers',
        queryParameters: {'email': email},
        options: Options(headers: {
          'Authorization': _basicAuth,
        }));
    if (response.statusCode == 200 && response.data.isNotEmpty) {
      return User.fromJson(response
          .data[0]); // Assuming the email query returns the correct user
    } else {
      throw Exception('Failed to fetch user details by email');
    }
  }
}
