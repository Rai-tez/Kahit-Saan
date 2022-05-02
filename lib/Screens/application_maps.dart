import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kahit_saan/Models/google_maps_shapes.dart';
import 'package:kahit_saan/Screens/listahan_please.dart';
import 'package:kahit_saan/Services/Google_Services/places_services.dart';
import 'package:kahit_saan/Models/foodplace_model.dart';
import 'package:kahit_saan/Services/location_services.dart';
import 'package:kahit_saan/Models/picked_place_model.dart';
import 'package:kahit_saan/Widgets/function_button.dart';
import 'package:kahit_saan/Constants/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kahit_saan/Widgets/pop_up.dart';
import '../Widgets/pop_up.dart';
import '../Widgets/drawer_options.dart';
import 'package:audioplayers/audioplayers.dart';

class ApplicationMaps extends StatefulWidget {
  // INITIAL VALUES
  final Marker userMarker;
  final Circle userRadius;
  final LatLng currentPosition;
  final String positionLabel;
  final double defaultRadius;

  //constructor that gets initialized positions
  // ignore: use_key_in_widget_constructors
  const ApplicationMaps({
    required this.userMarker,
    required this.userRadius,
    required this.currentPosition,
    required this.positionLabel,
    required this.defaultRadius,
  });

  @override
  _ApplicationMapsState createState() => _ApplicationMapsState();
}

class _ApplicationMapsState extends State<ApplicationMaps> {
  //constructors for services and others
  final PlacesServices _placeService = PlacesServices();
  final LocationServices _locationServices = LocationServices();
  final GoogleMapShapes _googleShapes = GoogleMapShapes();

  // controller for google maps to set position
  final Completer<GoogleMapController> _complete = Completer();
  late GoogleMapController gControl;

  // google maps shapes
  late Marker userMarker;
  late MarkerId userMarkerId = userMarker.markerId;
  late Circle userRadius;
  late CircleId userRadiusId = userRadius.circleId;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  final Set<Polyline> _polylines = {};

  // location and radius of user and userRadius
  late String positionLabel;
  late LatLng currentPosition;
  late double radius;
  final double maxRadius = 2500;
  final double minRadius = 100;
  double zoom_level = 18.0;

  // AudioPLayer
  final audioPlayer = AudioPlayer();

  void playSound(String name) {
    AudioCache player = new AudioCache(fixedPlayer: audioPlayer);
    player.play(name);
  }

  // PickedPlace for the place
  late PickedPlace? pickedPlace;
  List<String> pickedChoiceLabelList = [
    'Napili',
    'Kahit ano po?',
    'Pinakamalapit',
  ];

  // for sliding panel widget
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _expanded = false;

  // text editing controller for search location
  TextEditingController addressTextEditingController = TextEditingController();

  // Strings for labels on the MAIN BUTTONS
  List<String> buttonLabels = [
    'Listahan Please',
    'Kahit Ano',
    'Pinaka malapit'
  ];
  String typeLabel = 'RESTAURANT';

  @override
  void initState() {
    super.initState();
    userMarker = widget.userMarker;
    userRadius = widget.userRadius;
    currentPosition = widget.currentPosition;
    positionLabel = widget.positionLabel;
    radius = widget.defaultRadius;
    setState(() {
      _circles.add(userRadius);
      _markers.add(userMarker);
    });
  }

  Future<bool> hasNetwork(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {}

    PopUp noNetwork = PopUp();
    noNetwork.showNoNetwork(context);
    return false;
  }

  /// ------------- FUNCTIONS OF TEXT SEARCH AND LOCATIONS -------------

  void searchLocationFunction(String text, BuildContext context) async {
    if (!await hasNetwork(context)) return;

    LocationServices location = LocationServices();
    LatLng? coordinates = await location.getCoordinatesFromAddress(text);
    if (coordinates != null) {
      updateLocation(coordinates);
    } else {
      // CONNECTION STILL LOADING PLEASE WAIT POPUP
    }
  }

  void updateLocation(LatLng coordinates) async {
    String address =
        await _locationServices.getAddressFromCoordinates(coordinates);
    setState(() {
      _circles.clear();
      _markers.clear();
      _polylines.clear();
      currentPosition = coordinates;
      positionLabel = address;
      userRadius = _googleShapes.userCircle(
          coordinates: currentPosition, radius: radius);
      userMarker = _googleShapes.userMarker(coordinates: currentPosition);
      _circles.add(userRadius);
      _markers.add(userMarker);
      moveCameraToLocation();
    });
  }

  void moveCameraToLocation() {
    gControl.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: zoom_level)));
  }

  /// ------------- FUNCTIONS OF THREE BUTTONS -------------
  void listahanPleaseFunction(BuildContext context) async {
    if (!await hasNetwork(context)) return;

    List<Results>? results = await _placeService.getNearbyFoodPlaces(
        radius, currentPosition, typeLabel.toLowerCase());

    if (results == null) {
      PopUp().showNotAvailable(context);
      return;
    }

    int? pickedPlaceIndex = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListahanPlease(
              results, currentPosition, typeLabel.toLowerCase())),
    ) as int?;

    if (pickedPlaceIndex != null) {
      updatePickedPlace(
        resultingPlace: results[pickedPlaceIndex],
        pickedChoiceLabel: pickedChoiceLabelList[0],
        results: results,
      );
      showPickedPlace(context);
    } else {
      updatePickedPlace(
        resultingPlace: Results(
            name: '',
            place_id: '',
            geometry: Geometry(location: RestoLocation(lat: 0, lng: 0)),
            vicinity: '',
            photos: []),
        pickedChoiceLabel: pickedChoiceLabelList[1],
        results: results,
      );
    }
  }

  void kahitAnoFunction(BuildContext context) async {
    if (!await hasNetwork(context)) return;

    List<Results>? results = await _placeService.getNearbyFoodPlaces(
        radius, currentPosition, typeLabel.toLowerCase());

    if (results == null) {
      PopUp().showNotAvailable(context);
      return;
    }

    if (results.isNotEmpty) {
      int randomPlaceIndex = Random().nextInt(results.length);
      updatePickedPlace(
        resultingPlace: results[randomPlaceIndex],
        pickedChoiceLabel: pickedChoiceLabelList[1],
      );
    } else {
      updatePickedPlace(
          resultingPlace: Results(
              name: '',
              place_id: '',
              geometry: Geometry(location: RestoLocation(lat: 0, lng: 0)),
              vicinity: '',
              photos: []),
          pickedChoiceLabel: "");
    }
    showPickedPlace(context);
  }

  void pinakamalapitFunction(BuildContext context) async {
    if (!await hasNetwork(context)) return;

    Results? result = await _placeService.getNearestRestaurant(
        currentPosition, typeLabel.toLowerCase());

    if (result == null) {
      PopUp().showNotAvailable(context);
      return;
    }

    if (result.place_id.isNotEmpty) {
      updatePickedPlace(
        resultingPlace: result,
        pickedChoiceLabel: pickedChoiceLabelList[2],
      );
    } else {
      updatePickedPlace(
          resultingPlace: Results(
              name: '',
              place_id: '',
              geometry: Geometry(location: RestoLocation(lat: 0, lng: 0)),
              vicinity: '',
              photos: []),
          pickedChoiceLabel: "");
    }
    showPickedPlace(context);
  }

  /// ------------- FUNCTIONS OF SHOWING RESULTS -------------
  void updatePickedPlace({
    required Results resultingPlace,
    required String pickedChoiceLabel,
    List<Results>? results,
  }) async {
    _markers.clear();
    _polylines.clear();
    _markers.add(_googleShapes.userMarker(coordinates: currentPosition));

    if (resultingPlace.name.isNotEmpty) {
      List<String> photoReference =
          _placeService.getPhotos(resultingPlace.photos);

      LatLng restoCoordinates = LatLng(resultingPlace.geometry.location.lat,
          resultingPlace.geometry.location.lng);

      Marker placeMarker = _googleShapes.foodMarker(
        place_id: resultingPlace.place_id,
        coordinates: restoCoordinates,
        info: "${resultingPlace.name}\n",
        action: () => showPickedPlace(context),
      );
      Polyline lineBetween = _googleShapes.lineNearestResto(
          currentPos: currentPosition, nextPos: restoCoordinates);
      double distanceBetween = _locationServices.getDistanceInMeters(
          currentPosition, restoCoordinates);

      pickedPlace = PickedPlace(
        pickedChoiceLabel: pickedChoiceLabel,
        name: resultingPlace.name,
        rating: resultingPlace.rating,
        userRatingsTotal: resultingPlace.user_ratings_total,
        photoReference: photoReference,
        location: restoCoordinates,
        placeMarker: placeMarker,
        lineBetween: lineBetween,
        distanceBetween: distanceBetween,
        priceLevel: resultingPlace.price_level,
        vicinity: resultingPlace.vicinity,
      );
      setState(() {
        _markers.add(placeMarker);
        _polylines.add(lineBetween);
      });
      await Future.delayed(const Duration(milliseconds: 500));
      gControl.showMarkerInfoWindow(MarkerId(resultingPlace.place_id));
    } else {
      pickedPlace = null;
    }
    setState(() {
      switch (pickedChoiceLabel) {
        case 'Pinakamalapit':
          _circles.clear();
          break;
        default:
          _circles.add(userRadius);
      }
      if (results != null) {
        for (Results places in results) {
          _markers.add(_googleShapes.foodMarker(
            place_id: places.place_id,
            coordinates: LatLng(
                places.geometry.location.lat, places.geometry.location.lng),
            info: places.name,
            action: (resultingPlace.name != places.name)
                ? null
                : () => showPickedPlace(context),
          ));
        }
      }
    });
  }

  void showPickedPlace(BuildContext context) {
    ResultPopUp result = ResultPopUp();
    result.showRestaurant(
        context: context, place: pickedPlace, type: typeLabel);
  }

  void pickTypeFunction(BuildContext context) async {
    TypePopUp typePopUp = TypePopUp();
    String type = await typePopUp.filterOptions(context);
    setState(() {
      typeLabel = type.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    //responsive size
    double phoneScreenHeight = MediaQuery.of(context).size.height;
    double phoneScreenWidth = MediaQuery.of(context).size.width;

    //double appbar_screen_height = phone_screen_height / 13;
    double panelCollapsedHeight = phoneScreenHeight / 9;
    double panelMaxHeight = phoneScreenHeight / 1.5;
    double panelWidth = phoneScreenWidth / 30;
    double drawerWidth = phoneScreenWidth * 0.60;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: kyellow,
        key: scaffoldKey,
        drawer: SizedBox(width: drawerWidth, child: DrawerMenu()),
        body: SlidingUpPanel(
          snapPoint: 0.2,
          color: kyellow,
          backdropEnabled: true,
          borderRadius: topLeftRight_border,
          maxHeight: panelMaxHeight,
          minHeight: panelCollapsedHeight,
          collapsed: Center(
            child: Container(
                padding: const EdgeInsets.all(5.0),
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Icon(Icons.maximize_rounded, color: kbrown),
                )),
          ),

          /// ------------- SLIDING PANEL ON THE BOTTOM -------------
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ----------- SEARCH RADIUS -----------
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
                    child: Text(
                      "Search Radius: ${radius.round()} m",
                      style: ksearchRadius,
                    ),
                  ),
                  Slider(
                    activeColor: kbeige,
                    inactiveColor: Colors.white38,
                    thumbColor: kbrown,
                    value: radius,
                    max: maxRadius,
                    min: minRadius,
                    onChanged: (value) {
                      setState(() {
                        radius = value;
                        userRadius = _googleShapes.userCircle(
                            coordinates: currentPosition, radius: radius);
                        _circles.add(userRadius);
                      });
                    },
                  ),
                ],
              ),

              /// ----------- FILTER BUTTON -----------
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white38,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        playSound('all.wav');
                        pickTypeFunction(context);
                      },
                      child: Text(
                        typeLabel,
                        style: ktypeButton,
                      ),
                    ),
                  ),
                ),
              ),

              /// ----------- THREE BUTTONS -----------
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 20, bottom: 80.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white38,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: FunctionButton(
                            text: buttonLabels[0],
                            icon: const Icon(
                              Icons.menu_book_outlined,
                              color: kbrown,
                              size: 40,
                            ),
                            onPressed: () async {
                              playSound('listahan.wav');
                              listahanPleaseFunction(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: FunctionButton(
                            text: buttonLabels[1],
                            icon: const Icon(
                              Icons.fastfood_outlined,
                              color: kbrown,
                              size: 40,
                            ),
                            onPressed: () async {
                              playSound('popup.wav');
                              kahitAnoFunction(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: FunctionButton(
                            text: buttonLabels[2],
                            icon: const Icon(
                              Icons.near_me_outlined,
                              color: kbrown,
                              size: 40,
                            ),
                            onPressed: () async {
                              playSound('popup.wav');
                              pinakamalapitFunction(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// -------------- ACTUAL MAP AND SEARCH BAR --------------
          body: Stack(
            children: [
              /// ------------ GOOGLE MAP ------------
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: currentPosition, zoom: zoom_level),
                markers: _markers,
                circles: _circles,
                polylines: _polylines,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                onMapCreated: (GoogleMapController ctrl) {
                  _complete.complete(ctrl);
                  gControl = ctrl;
                },
                onTap: (_) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _expanded = false;
                  });
                },
                onLongPress: (preferredPosition) async {
                  Map<String, dynamic> adjustLocation = await _locationServices
                      .placeMarkerLocation(preferredPosition, radius);
                  _markers.clear();
                  _circles.clear();
                  _polylines.clear();
                  setState(() {
                    userRadius = adjustLocation["user_circle"];
                    userMarker = adjustLocation["user_marker"];
                    positionLabel = adjustLocation["address_after"];
                    currentPosition = preferredPosition;
                    _markers.add(userMarker);
                    _circles.add(userRadius);
                  });
                  moveCameraToLocation();
                },
                onCameraMove: (CameraPosition camera) {
                  zoom_level = camera.zoom;
                },
              ),

              /// ------------ SEARCH BAR ------------
              Column(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  color: Colors.green,
                  child: ExpansionPanelList(
                    expandedHeaderPadding: const EdgeInsets.all(0),
                    animationDuration: const Duration(milliseconds: 500),
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return TextField(
                            onTap: () {
                              setState(() {
                                _expanded = true;
                              });
                            },
                            onSubmitted: (text) async {
                              searchLocationFunction(text, context);
                            },
                            keyboardType: TextInputType.streetAddress,
                            controller: addressTextEditingController,
                            decoration: const InputDecoration(
                                hintText: "Search Location",
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search_rounded)),
                          );
                        },
                        body: TextButton(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.my_location,
                                  color: kyellow,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Use Current Location",
                                  style: kcurrLocButton,
                                ),
                              ]),
                          onPressed: () async {
                            LatLng? coordinates =
                                await _locationServices.getCurrentCoordinates();
                            if (coordinates != null) {
                              updateLocation(coordinates);
                            }
                          },
                        ),
                        isExpanded: _expanded,
                        canTapOnHeader: true,
                      ),
                    ],
                    dividerColor: Colors.grey,
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Row(
            children: [
              ElevatedButton(
                  child: Image.asset(
                    "images/icon1.png",
                    width: 30,
                    height: 30,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kbeige,
                    onPrimary: kbrown,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    playSound('drawer.wav');
                    scaffoldKey.currentState?.openDrawer();
                  }),
              const Spacer(),
              const Icon(
                Icons.location_pin,
                color: kred,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                child: Flexible(
                  child: Text(
                    positionLabel,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.right,
                    style: kcurrLoc,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
