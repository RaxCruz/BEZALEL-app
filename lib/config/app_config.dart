import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AppConfig {
  static const String baseUrl = 'https://bezalel.tw';

  static String get consumerKey => dotenv.env['CONSUMER_KEY'] ?? '';
  static String get consumerSecret => dotenv.env['CONSUMER_SECRET'] ?? '';

  static String get basicAuthCredentials {
    return base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
  }
}
