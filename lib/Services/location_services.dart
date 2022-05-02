import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kahit_saan/Models/google_maps_shapes.dart';

class LocationServices {

  // gets location
  Future<LatLng?> getCurrentCoordinates() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> getAddressFromCoordinates(LatLng location) async {
    List<Placemark> currentAddress = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    // Street + Locality
    String? street = currentAddress[0].street;
    String? locality = currentAddress[0].locality;
    String address = '';

    address += street ?? '';
    address += locality != null ? ', ' + locality : '';

    return address;
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return LatLng(locations[0].latitude, locations[0].longitude);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> placeMarkerLocation(
      LatLng preferredPosition, double radius) async {
    String addressAfter = await getAddressFromCoordinates(preferredPosition);
    GoogleMapShapes shapes = GoogleMapShapes();
    Marker userMarker = shapes.userMarker(coordinates: preferredPosition);
    Circle userCircle =
        shapes.userCircle(coordinates: preferredPosition, radius: radius);

    return {
      "user_marker": userMarker,
      "user_circle": userCircle,
      "address_after": addressAfter
    };
  }

  double getDistanceInMeters(LatLng currentLocation, LatLng targetLocation) {
    return Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        targetLocation.latitude,
        targetLocation.longitude);
  }
}
