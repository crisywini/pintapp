class APIConstants {
  static const String baseUrl = "//192.168.20.15:5000/";
  static const String itemServiceUrl = "items";
  static const String outfitsServiceUrl = "outfits";
  static const String categoriesServiceUrl = "categories/outfits";
}

enum Environment { dev, staging, prod }

class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.dev;
  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return APIConstants.baseUrl;
      case Environment.staging:
        return "APIConstants.baseUrl";
      case Environment.prod:
        return "APIConstants.baseUrl";
    }
  }
}
