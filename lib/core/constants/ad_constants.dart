import 'dart:io';
import 'package:flutter/foundation.dart';

class AdConstants {
  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7763617297114393~8207179142';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7763617297114393~8207179142';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      // IDs de Teste Oficiais da Google
      return Platform.isAndroid 
        ? 'ca-app-pub-3940256099942544/6300978111' 
        : 'ca-app-pub-3940256099942544/2934735716';
    }
    
    if (Platform.isAndroid) {
      return 'ca-app-pub-7763617297114393/2954852464';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7763617297114393/2954852464';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
