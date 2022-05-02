import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kahit_saan/Constants/constants.dart';
import 'package:kahit_saan/Models/google_maps_shapes.dart';
import 'package:kahit_saan/Screens/application_maps.dart';
import 'package:kahit_saan/Services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kahit_saan/Widgets/pop_up.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleMapShapes shapes = GoogleMapShapes();
  late Marker userMarker;
  late Circle userRadius;
  late LatLng currentPosition;
  late String locationLabel;
  double defaultRadius = 100;
  late BuildContext contxt;

  Future<bool> hasNetwork(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}

    PopUp noNetwork = PopUp();
    await noNetwork.showNoNetwork(context);
    return false;
  }

  Future<void> getLocationData() async {
    while (!await hasNetwork(context)) {
      await Future.delayed(const Duration(seconds: 15));
    }

    LocationServices _locationService = LocationServices();
    LatLng? coordinates = await _locationService.getCurrentCoordinates();
    if (coordinates != null) {
      locationLabel =
          await _locationService.getAddressFromCoordinates(coordinates);
      currentPosition = LatLng(coordinates.latitude, coordinates.longitude);
      userRadius = shapes.userCircle(
          coordinates: currentPosition, radius: defaultRadius);
      userMarker = shapes.userMarker(coordinates: currentPosition);
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ApplicationMaps(
              currentPosition: currentPosition,
              userMarker: userMarker,
              userRadius: userRadius,
              positionLabel: locationLabel,
              defaultRadius: defaultRadius,
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    contxt = context;

    return Scaffold(
      backgroundColor: kyellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'images/icon1.png',
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kahit Saan",
              style: ksplashScreen,
            ),
            const SizedBox(height: 50),
            const SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                strokeWidth: 2.5,
              ),
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
