import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kahit_saan/Constants/constants.dart';

/*
* This dart file and class shows the shapes that are seen throughout the map
*
* WARNING: Please do not change anything in the code, if you wish to change
* any attributes within the shapes like color, please go to constants.dart
*
* any other changes must be discussed with me(Drei)
* */
class GoogleMapShapes {
  //user Circle
  Circle userCircle({required LatLng coordinates, required double radius}) {
    return Circle(
      circleId: const CircleId("Detector_Radius"),
      center: coordinates,
      radius: radius,
      strokeWidth: circle_stroke_width,
      strokeColor: circle_edge_color,
      fillColor: circle_area_color, //alpha,
    );
  }

  //user Marker
  Marker userMarker({required LatLng coordinates}) {
    return Marker(
        markerId: MarkerId("user_pin"),
        position: coordinates,
        infoWindow: InfoWindow(title: "You are here"));
  }

  //Restaurant Marker
  Marker foodMarker(
      {required String place_id,
      required LatLng coordinates,
      required String info,
      Function()? action}) {
    return Marker(
        markerId: MarkerId(place_id),
        position: coordinates,
        infoWindow: InfoWindow(title: info),
        icon: resto_color_marker,
        onTap: action);
  }

  // line nearest
  Polyline lineNearestResto(
      {required LatLng currentPos,
      required LatLng nextPos,
      Function()? action}) {
    return Polyline(
        polylineId: const PolylineId('line_from_current_to_nearest'),
        points: [currentPos, nextPos],
        width: line_width,
        patterns: [line_pattern],
        color: line_color,
        onTap: action);
  }

  // line in random picking
  Polyline lineRandomResto(
      {String? line_id,
      required LatLng currentPos,
      required LatLng nextPos,
      Function()? action}) {
    return Polyline(
        polylineId: PolylineId(line_id == null ? "" : line_id),
        points: [currentPos, nextPos],
        width: line_width,
        patterns: [line_pattern],
        color: line_color,
        onTap: action);
  }
}
