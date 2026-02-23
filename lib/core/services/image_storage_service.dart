import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageStorageService {
  ImageStorageService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  Future<String> copyImageToAppData(String originalPath) async {
    final appDir = await getApplicationSupportDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'vision_images'));
    await imagesDir.create(recursive: true);

    final extension = p.extension(originalPath).isEmpty
        ? '.img'
        : p.extension(originalPath);
    final destination = File(p.join(imagesDir.path, '${_uuid.v4()}$extension'));
    await File(originalPath).copy(destination.path);
    return destination.path;
  }
}
