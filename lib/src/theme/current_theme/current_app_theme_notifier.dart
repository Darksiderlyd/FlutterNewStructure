import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:readbook/src/theme/current_theme/current_app_theme_service.dart';

part 'current_app_theme_notifier.g.dart';

@riverpod
class CurrentAppThemeNotifier extends _$CurrentAppThemeNotifier {
  late CurrentAppThemeService _currentAppThemeService;

  CurrentAppThemeNotifier() : super();

  Future<void> updateCurrentAppTheme(bool isDarkMode) async {
    final success =
    await _currentAppThemeService.setCurrentAppTheme(isDarkMode);

    if (success) {
      state = AsyncValue.data(
        isDarkMode ? CurrentAppTheme.dark : CurrentAppTheme.light,
      );

      if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode
              ? Brightness.light
              : Brightness.dark,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    }
  }

  @override
  Future<CurrentAppTheme> build() async {
    _currentAppThemeService = ref.read(currentAppThemeServiceProvider);
    return _currentAppThemeService.getCurrentAppTheme();
  }
}

enum CurrentAppTheme {
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  final ThemeMode themeMode;
  const CurrentAppTheme(this.themeMode);
}
