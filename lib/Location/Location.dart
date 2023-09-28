import 'package:geolocator/geolocator.dart';

class GetLocation {

  static Future<Position> getLocation() async {

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}
