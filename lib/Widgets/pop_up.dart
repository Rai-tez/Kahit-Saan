import 'package:flutter/material.dart';
import 'package:kahit_saan/Services/Google_Services/places_services.dart';
import 'package:kahit_saan/Constants/constants.dart';
import 'package:kahit_saan/Models/picked_place_model.dart';
import 'package:kahit_saan/Widgets/pili_ka_muna_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:audioplayers/audioplayers.dart';

// AudioPlayer
final audioPlayer = new AudioPlayer();

void playSound(String name) {
  AudioCache player = new AudioCache(fixedPlayer: audioPlayer);
  player.play(name);
}

class PopUp {
  var alertStyle = const AlertStyle(
    backgroundColor: kyellow,
    animationType: AnimationType.grow,
    isButtonVisible: false,
    titleStyle: ktitle,
  );

  Future<void> showNoNetwork(BuildContext context) async {
    await Alert(
      style: alertStyle,
      context: context,
      title: 'No Internet Connection',
      content: const Text(
        'Please check if you\'re connected to the internet.',
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    ).show();
  }

  void showNotAvailable(BuildContext context) {
    Alert(
      style: alertStyle,
      context: context,
      title: 'Sorry! :(',
      content: const Text(
        'Our services aren\'t available right now. Please try again later.',
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    ).show();
  }
}

class ResultPopUp extends PopUp {
  final PlacesServices _placeService = PlacesServices();

  void showRestaurant(
      {required BuildContext context,
      required PickedPlace? place,
      required String type,
      bool? fromListahan}) async {
    /// if theres a result
    if (place != null) {
      Alert(
        style: alertStyle,
        context: context,
        title: place.pickedChoiceLabel,
        content: Column(
            children: foodPlaceInfo(
          photoReference:
              place.photoReference.isNotEmpty ? place.photoReference[0] : '',
          name: place.name,
          rating: place.rating,
          userRatingsTotal: place.userRatingsTotal,
          distanceBetween: place.distanceBetween,
          priceLevel: place.priceLevel,
          vicinity: place.vicinity,
          fromListahan: fromListahan,
        )),
      ).show();
    }

    /// if no result
    else {
      Alert(
        style: alertStyle,
        context: context,
        title: 'Wala po :(',
        content: Column(children: [
          const SizedBox(height: 10),
          Icon(
            Icons.search_rounded,
            size: MediaQuery.of(context).size.height / 7,
            color: kgrey,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
              "No ${type.toLowerCase()} nearby or within the circle",
              textAlign: TextAlign.center,
              style: knoResult,
            ),
          ),
        ]),
      ).show();
    }
  }

  // you may delete this whenever necessary
  List<Widget> foodPlaceInfo({
    required String photoReference,
    required String? name,
    required String? rating,
    required String? userRatingsTotal,
    required double distanceBetween,
    required String? priceLevel,
    required String? vicinity,
    bool? fromListahan,
  }) {
    String ratingFormat = rating!.contains("No rating") ? "N/A" : "$rating / 5";
    return [
      Container(
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: _placeService.fetchPhoto(photoReference).image,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
      ),
      Container(
        decoration: const BoxDecoration(
            color: kwhite,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(blurRadius: 2.0, spreadRadius: 1.0, color: kgrey),
            ]),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              "$name",
              textAlign: TextAlign.center,
              style: kplaceName,
            ),
            Text(
              "Rating: $ratingFormat ",
              textAlign: TextAlign.center,
              style: kdescription,
            ),
            Text(
              "Total Ratings: $userRatingsTotal",
              textAlign: TextAlign.center,
              style: kdescription,
            ),
            Text(
              "Distance : ${distanceBetween.round().toString()} m",
              textAlign: TextAlign.center,
              style: kdescription,
            ),
            Text(
              "Price Level: $priceLevel",
              textAlign: TextAlign.center,
              style: kdescription,
            ),
            Text(
              "Vicinity: $vicinity",
              textAlign: TextAlign.center,
              style: kdescription,
            ),
          ],
        ),
      ),
    ];
  }
}

class TypePopUp extends PopUp {
  String _type = 'restaurant'; // default value

  Future<String> filterOptions(BuildContext context) async {
    await Alert(
      style: alertStyle,
      context: context,
      title: 'Anong kainan?',
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: kyellow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: PiliKaButton(
                      text: "Resto",
                      icon: const Icon(
                        Icons.storefront,
                        color: kbrown,
                        size: 40,
                      ),
                      onPressed: () {
                        playSound('all.wav');
                        _type = 'restaurant';
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: PiliKaButton(
                      text: "Cafe",
                      icon: const Icon(
                        Icons.local_cafe,
                        color: kbrown,
                        size: 40,
                      ),
                      onPressed: () {
                        playSound('all.wav');
                        _type = 'cafe';
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: PiliKaButton(
                      text: "Bar",
                      icon: const Icon(
                        Icons.local_bar,
                        color: kbrown,
                        size: 40,
                      ),
                      onPressed: () {
                        playSound('all.wav');
                        _type = 'bar';
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: PiliKaButton(
                      text: "Bakery",
                      icon: const Icon(
                        Icons.bakery_dining,
                        color: kbrown,
                        size: 40,
                      ),
                      onPressed: () {
                        playSound('all.wav');
                        _type = 'bakery';
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show();

    return _type;
  }
}
