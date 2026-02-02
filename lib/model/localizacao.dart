import 'package:camera_overlay/camera_overlay.dart' as cam;

class Localizacao {
  final double lat;
  final double log;
  final double alt;
  final DateTime data;

  Localizacao.fromCamera(cam.Localizacao l)
    : lat = l.latitude,
      log = l.longitude,
      alt = l.altitude,
      data = l.data;
}
