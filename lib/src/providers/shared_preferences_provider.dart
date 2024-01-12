import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbook/src/common/libcommon.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => LocalStorage().getSharedPreferences()!,
);
