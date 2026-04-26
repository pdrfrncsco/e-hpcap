import 'package:flutter/foundation.dart';

enum Environment { dev, staging, prod }

class AppEnvironment {
  static late Environment _environment;
  static void setup(Environment env) {
    _environment = env;
  }

  static Environment get current => _environment;

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        // Alterado para conectar com a produção mesmo em dev (Chrome/Web)
        return 'https://hpcapi.eclezzia.com/api/';
      case Environment.staging: 
        return 'https://staging.eclezzia.com/api/';
      case Environment.prod:
        return 'https://hpcapi.eclezzia.com/api/';
    }
  }

  static bool get isDev => _environment == Environment.dev;

 
}
