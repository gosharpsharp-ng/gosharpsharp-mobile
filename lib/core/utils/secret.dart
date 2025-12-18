import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secret {
  static String get apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
