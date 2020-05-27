import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Storage {
  Storage._();

  static final Storage internal = Storage._();

  factory Storage() => internal;

  static const APP_FOLDER = "Creator";

  static Future<Directory> get externalStorageDirectory async {
    Directory dir;
    await getExternalStorageDirectory().then((directory) async {
      String androidPath =
          Directory(directory.parent.parent.parent.parent.path).path;
      dir = Directory([androidPath, "$APP_FOLDER/"].join("/"));
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    });
    return dir;
  }

  static Future<String> get externalStoragePath async {
    Directory dir = await externalStorageDirectory;
    return dir.path;
  }

  static Future<bool> saveImage(Uint8List file) async {
    Permission permission = Permission.storage;
    while (!(await permission.isGranted)) {
      await permission.request();
    }
    bool saved = false;
    try {
      String imagePath = await externalStoragePath;
      imagePath += "${DateTime.now().millisecondsSinceEpoch}.png";
      File imageFile = File(imagePath);
      Image image = decodeImage(file);
      await imageFile.writeAsBytes(encodePng(
        image,
      ));
      saved = true;
    } catch (e) {
      print(e);
    }
    return saved;
  }
}
