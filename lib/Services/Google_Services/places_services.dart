import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kahit_saan/Models/foodplace_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:kahit_saan/Widgets/pop_up.dart';

// enums can be used, but for this is used for showing other types that might be used
enum FoodPlaceType { restaurant, cafe, bakery, bar }

class PlacesServices {
  /// -------------  DO NOT CHANGE -------------
  //PRIVATE KEY, might move somewhere else safer, will deactivate key once 90 days trial is done
  // at Feb 21, 2022 [02/21/2022]
  final String _apiKey = ""; //ENTER YOUR OWN API KEY FROM GOOGLE APIS 
  final String _baseUrl =
      'https://maps.googleapis.com/maps/api/place'; // BASE URL
  /// ------------- DO NOT CHANGE -------------

  Future<List<Results>?> getNearbyFoodPlaces(
      double radius, LatLng coordinates, String type) async {
    //URL for getting json equivalent of nearby restaurants and its type
    //within certain radius
    Uri url = Uri.parse('$_baseUrl/nearbysearch/json?'
        'location=${coordinates.latitude},${coordinates.longitude}'
        '&radius=${radius.round()}'
        '&types=$type'
        '&key=$_apiKey');

    List<Results> results = [];
    var response = await http.get(url); // fetches json from internet
    int status = response.statusCode;

    // if status = OK, do below
    if (status == 201 || status == 200) {

      // converts json results into list resto[0], resto[1], resto[2]... resto[n]
      List<dynamic> json = convert.jsonDecode(response.body)["results"];

      // converts json[i] into Result classes
      // by far this is the most efficient method I could think of, might change to functional statement if better
      for (int i = 0; i < json.length; i++) {
        results.add(Results.fromJson(json[i]));
      }
    }
    // if status 400 or 404 or 500, do below
    else {
      return null;
    }
    return results;
  }

  Future<Results?> getNearestRestaurant(LatLng coordinates, String type) async {
    //initialize by default
    Results result = Results(
        name: '',
        place_id: '',
        geometry: Geometry(location: RestoLocation(lat: 0, lng: 0)),
        vicinity: '',
        photos: []);

    Uri url = Uri.parse('$_baseUrl/nearbysearch/json?'
        'location=${coordinates.latitude},${coordinates.longitude}'
        '&type=$type'
        '&rankby=distance'
        '&key=$_apiKey');

    var response = await http.get(url);
    int status = response.statusCode;

    // if status = OK, do below
    if (status == 201 || status == 200) {

      // json is still indexed even if the result is only 1
      // so we specify the first result by indicating index with [0]

      result = Results.fromJson(convert.jsonDecode(response.body)["results"][0]);
      return result;
    }
    // if status 400 or 404 or 500, do below
    else {
      return null;
    }
  }

  /// below are photo related functions

  Image fetchPhoto(String photoReference) {
    if (photoReference.isEmpty) {
      return Image.asset(
        "images/noResult.PNG",
        height: 350,
      );
    } else {
      //returns Image using network image and the url
      String url = "$_baseUrl/photo?"
          "photoreference=$photoReference"
          "&sensor=false"
          "&maxheight=1600"
          "&maxwidth=1600"
          "&key=$_apiKey";

      return Image(
        image: NetworkImage(url),
        height: 350,
      );
    }
  }

  List<String> getPhotos(List<dynamic> photos) {
    List<String> photoList = [];
    for (int i = 0; i < photos.length; i++) {
      Photos photo = Photos.fromJson(photos[i]);
      photoList.add(photo.photo_reference);
    }
    return photoList;
  }

  String? fetchUrlPhoto(String photoReference) {
    if (photoReference.isEmpty) {
      return null;
    } else {
      String url = "$_baseUrl/photo?"
          "photoreference=$photoReference"
          "&sensor=false"
          "&maxheight=1600"
          "&maxwidth=1600"
          "&key=$_apiKey";
      return url;
    }
  }
}
