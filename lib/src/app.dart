import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:readbook/src/common/router/router.dart';
import 'package:readbook/src/constants/strings.dart';
import 'package:readbook/src/theme/current_theme/current_app_theme_notifier.dart';
import 'package:readbook/src/theme/theme_config.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);

    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: currentAppTheme.value == CurrentAppTheme.dark
            ? Brightness.light
            : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return OKToast(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: themeData(
          currentAppTheme.value == CurrentAppTheme.dark
              ? darkTheme
              : lightTheme,
        ),
        darkTheme: themeData(darkTheme),
        themeMode: currentAppTheme.value?.themeMode,
        routerConfig: router,
      ),
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}
