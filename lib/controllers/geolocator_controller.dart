import 'package:dart_geohash/dart_geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeolocatorController extends GetxController {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  late final GeoHasher geoHasher;

  GeolocatorController() {
    geoHasher = GeoHasher();
    getCurrentLocation();
  }

  Future<Position?> getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
    currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return currentPosition.value;
  }

  String? getGeoHash() {
    if (currentPosition.value == null) {
      return null;
    }
    return geoHasher.encode(
        currentPosition.value!.longitude, currentPosition.value!.latitude);
  }

  double? getDistance(double lat, double lng) {
    if (currentPosition.value == null) {
      return null;
    }
    return Geolocator.distanceBetween(currentPosition.value!.latitude,
        currentPosition.value!.longitude, lat, lng);
  }

  List<double> getPositionFromGeoHash(String geoHash) {
    return geoHasher.decode(geoHash);
  }
}
