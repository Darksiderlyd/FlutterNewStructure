import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readbook/src/feature/splash/notifiers/file_notifier.dart';
import 'package:riverpod/riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void startTimeout() {
    Timer(const Duration(seconds: 2), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  Future<void> changeScreen() async {}

  @override
  void initState() {
    super.initState();
    startTimeout();
    checkPermissionAndDownload();
  }

  Future<void> checkPermissionAndDownload() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      // access media location needed for android 10/Q
      await Permission.accessMediaLocation.request();
      // manage external storage needed for android 11/R
      await Permission.manageExternalStorage.request();

      ref.read(fileNotifierProvider.notifier).getFiles();
    } else {
      ref.read(fileNotifierProvider.notifier).getFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/images/app-icon.png',
                height: 100.0,
                width: 100.0,
              ),
            ),
            ref.watch(fileNotifierProvider).maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Text('加载中...'),
                  data: (data) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            final path = data[index].path;
                            final bookFile = File(path);
                            if (bookFile.existsSync()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return EpubScreen.fromPath(filePath: path);
                                  },
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(data[index].path),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
