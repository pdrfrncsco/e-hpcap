import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingPreferences {
  final double fontSizeMultiplier;
  final bool keepScreenOn;

  const ReadingPreferences({
    this.fontSizeMultiplier = 1.0,
    this.keepScreenOn = true,
  });

  ReadingPreferences copyWith({
    double? fontSizeMultiplier,
    bool? keepScreenOn,
  }) {
    return ReadingPreferences(
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
    );
  }
}

class ReadingPreferencesNotifier extends StateNotifier<ReadingPreferences> {
  ReadingPreferencesNotifier() : super(const ReadingPreferences()) {
    _load();
  }

  static const _keyFontSize = 'hpc_reader_font_size';
  static const _keyKeepScreenOn = 'hpc_reader_keep_screen';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReadingPreferences(
      fontSizeMultiplier: prefs.getDouble(_keyFontSize) ?? 1.0,
      keepScreenOn: prefs.getBool(_keyKeepScreenOn) ?? true,
    );
  }

  Future<void> setFontSizeMultiplier(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, value);
    state = state.copyWith(fontSizeMultiplier: value);
  }

  Future<void> setKeepScreenOn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKeepScreenOn, value);
    state = state.copyWith(keepScreenOn: value);
  }
}

final readingPreferencesProvider =
    StateNotifierProvider<ReadingPreferencesNotifier, ReadingPreferences>((ref) {
  return ReadingPreferencesNotifier();
});
