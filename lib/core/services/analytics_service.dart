import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log de login
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Log de registro
  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // Log de visualização de hino
  static Future<void> logHinoViewed({
    required int hinoId,
    required String hinoTitle,
  }) async {
    await _analytics.logEvent(
      name: 'view_hino',
      parameters: {
        'hino_id': hinoId,
        'hino_title': hinoTitle,
      },
    );
  }

  // Log de busca
  static Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // Log genérico
  static Future<void> logCustomEvent(String name, Map<String, Object>? params) async {
    await _analytics.logEvent(name: name, parameters: params);
  }

  // Definir propriedades do usuário (ex: se é membro de uma igreja)
  static Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
