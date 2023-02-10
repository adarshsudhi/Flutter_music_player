import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Audiofetch {
  Getpermission() async {
    try {
      var result = await Permission.storage.status;
      if (result.isDenied) {
        Map<Permission, PermissionStatus> status = await [
          Permission.camera,
          Permission.storage,
        ].request();
      }
    } catch (e) {
      print(e);
    }
  }
}
