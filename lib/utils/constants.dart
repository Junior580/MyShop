import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final BASE_API_URL = "${dotenv.env['BASE_API_URL']!}";

  static String getLoginUrl(String urlSegment) {
    return "${dotenv.env['AUTH_API_URL']!}$urlSegment?key=${dotenv.env['API_KEY']!}";
  }
}
