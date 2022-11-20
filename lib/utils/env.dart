import 'package:flutter_dotenv/flutter_dotenv.dart';

String getEnvValue(String envKey) {
  String? value = dotenv.env[envKey];
  if (value == null) {
    throw Exception("Missing $envKey in .env");
  }
  return value;
}
