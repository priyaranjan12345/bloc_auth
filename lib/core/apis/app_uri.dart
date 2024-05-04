class AppUri {
  AppUri._();

  static const String _baseUrl = "http://numbersapi.com/";

  static Uri getUri({required String path}) => Uri.parse(_baseUrl + path);
}
