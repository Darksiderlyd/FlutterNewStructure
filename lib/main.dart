import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbook/src/app.dart';
import 'package:readbook/src/common/database/database_config.dart';
import 'package:readbook/src/common/local/local_storage.dart';
import 'package:readbook/src/theme/current_theme/current_app_theme_service.dart';
import 'package:sembast/sembast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage();
  await DatabaseConfig.init(StoreRef<dynamic, dynamic>.main());
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
