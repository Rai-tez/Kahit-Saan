import 'package:google_maps_flutter/google_maps_flutter.dart';

///this is a model for the chosen place of the user via "Listahan Please",
///"Kahit ano", and "Pinakamalapit"

class PickedPlace {

  ///this holds the title of the action that is chosen by the user
  ///Listahan Please = "Napili"
  ///Listahan Please but user pressed back = "" //no title or null
  ///Kahit Ano = "Kahit Ano"
  ///Pinakamalapit = "Pinakamalapit"
  late String pickedChoiceLabel;

  ///name of eatery
  late String name;

  ///ratings of a certain eatery ranging from 0 - 5
  ///if there are no ratings, string is null
  late String? rating;

  ///number of ratings received by the restaurant
  ///if there are no ratings, string is null
  late String? userRatingsTotal;

  ///stores a list of string of photo_references for http get
  ///that is associated with the eatery
  late List<String> photoReference;

  ///stores latitude[double] and longitude[double] positions of the eatery in google maps
  late LatLng location;

  ///initializes the marker containing its name[String], location[LatLng]
  ///that will be placed in google maps later
  late Marker placeMarker;

  ///initializes the polyline containing location of user[LatLng] and location of eatery[LatLng]
  ///that will be placed in google maps later
  late Polyline lineBetween;

  ///distance of user from eatery in meters
  late double distanceBetween;

  ///this shows the price level of the eatery ranging from 0(free) - 5(expensive)
  ///if String is null, then price level is not present in the eatery information json
  late String? priceLevel;

  ///the address of the eatery
  ///can be null if not specified in the json
  late String? vicinity;

  PickedPlace({
    required this.pickedChoiceLabel,
    required this.name,
    required this.rating,
    required this.userRatingsTotal,
    required this.photoReference,
    required this.location,
    required this.placeMarker,
    required this.lineBetween,
    required this.distanceBetween,
    required this.priceLevel,
    required this.vicinity,
  });
}
