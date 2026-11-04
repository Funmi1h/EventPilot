import 'dart:typed_data';
import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart' as platform;

//fonction publique pour declencher le telechargement de bytes
void downloadFile(Uint8List bytes, String fileName) {
  platform.downloadBytes(bytes, fileName);
}

