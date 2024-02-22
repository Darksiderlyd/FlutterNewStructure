import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;

part 'file_notifier.g.dart';

const String appName = 'OpenLeaf';

@riverpod
class FileNotifier extends _$FileNotifier {
  @override
  Future<List<FileSystemEntity>> build() async {
    return _getFiles();
  }

  Future<void> getFiles() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _getFiles());
  }

  Future<List<FileSystemEntity>> _getFiles() async {
    final appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final String dirPath = path.join(appDocDir!.path, appName);
    Directory? dir = null;
    if (Platform.isAndroid) {
      dir = Directory(appDocDir.path.split('Android')[0] + appName);
    } else {
      dir = Directory(dirPath);
    }

    if (!dir.existsSync()) {
      return [];
    }

    return dir.listSync();
  }
}
