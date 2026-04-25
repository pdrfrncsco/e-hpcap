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
        // No Android, o emulador acede ao localhost da máquina hospedeira através do 10.0.2.2
        // Para dispositivo físico na mesma rede Wi-Fi, alterar para o IP local (ex: 192.168.1.X)
        // Para iOS Simulator, pode ser 127.0.0.1 ou localhost
        return 'http://192.168.101.34:8000/api/'; // http://192.168.101.34:8000/api/
      case Environment.staging: 
        return 'https://staging.eclezzia.com/api/';
      case Environment.prod:
        return 'https://hpcapi.eclezzia.com/api/';
    }
  }

  static bool get isDev => _environment == Environment.dev;

 
}
