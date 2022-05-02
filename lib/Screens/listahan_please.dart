import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kahit_saan/Constants/constants.dart';
import 'package:kahit_saan/Services/Google_Services/places_services.dart';
import 'package:kahit_saan/Models/foodplace_model.dart';
import 'package:kahit_saan/Services/location_services.dart';
import 'package:audioplayers/audioplayers.dart';

class ListahanPlease extends StatefulWidget {
  final List<Results> results;
  final LatLng currentPosition;
  final String foodPlaceType;

  const ListahanPlease(this.results, this.currentPosition, this.foodPlaceType,
      {Key? key})
      : super(key: key);

  @override
  _ListahanPleaseState createState() => _ListahanPleaseState();
}

class _ListahanPleaseState extends State<ListahanPlease> {
  final PlacesServices _placeService = PlacesServices();
  final LocationServices _locationServices = LocationServices();
  late final List<Results> results;
  late final LatLng currentPosition;

  // AudioPlayer
  final audioPlayer = AudioPlayer();

  // Scroll
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  void playSound(String name) {
    AudioCache player = AudioCache(fixedPlayer: audioPlayer);
    player.load(name);
    player.play(name);
  }

  dynamic getPlaceImage(String url) {
    String? newUrl;
    if (url.isNotEmpty) {
      newUrl = _placeService.fetchUrlPhoto(url);
    }

    return (newUrl == null
        ? const AssetImage('images/noResult.PNG')
        : NetworkImage(newUrl));
  }

  Container _buildItem(String title, String genAddress, double distance,
      String measure, String url, String? rating) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: getPlaceImage(url),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: kplaceName,
                      ),
                      Text(
                        genAddress,
                        style: kdescription,
                      ),
                      Text(
                        distance.round().toString() + measure,
                        style: kdescription,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: kyellow,
                  child: Text(
                    rating.toString(),
                    style: const TextStyle(color: kwhite),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildListView() {
    List<Widget> listViewChildren = [];
    int index = 0;
    if (results.isEmpty) {
      return [
        SizedBox(height: MediaQuery.of(context).size.height / 4),
        Icon(
          Icons.search_rounded,
          size: MediaQuery.of(context).size.height / 9,
          color: kbrown,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Text(
            "No ${widget.foodPlaceType} nearby or within the circle",
            textAlign: TextAlign.center,
            style: knoResult,
          ),
        ),
      ];
    }
    for (Results resultingPlace in results) {
      int currentIndex = index;

      LatLng restoCoordinates = LatLng(resultingPlace.geometry.location.lat,
          resultingPlace.geometry.location.lng);

      double distanceBetween = _locationServices.getDistanceInMeters(
          currentPosition, restoCoordinates);

      List<String> photoReference =
          _placeService.getPhotos(resultingPlace.photos);

      String? rating = resultingPlace.rating!.contains('No rating')
          ? 'N/A'
          : resultingPlace.rating;

      listViewChildren.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kbeige,
          onPrimary: Colors.black,
        ),
        onPressed: () {
          playSound("popup.wav");
          Navigator.of(context).pop(currentIndex);
        },
        child: _buildItem(
          resultingPlace.name,
          resultingPlace.vicinity ?? '',
          distanceBetween,
          " meters",
          photoReference.isNotEmpty ? photoReference[0] : '',
          rating ?? 'N/A',
        ),
      ));
      index++;
    }
    return listViewChildren;
  }

  void _scrollToTop() {
    playSound('all.wav');
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    results = widget.results;
    currentPosition = widget.currentPosition;
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbeige,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kyellow,
        elevation: 5,
        title: const Text(
          "Listahan",
          style: ktitle,
        ),
      ),
      body: Theme(
        data: ThemeData(
          highlightColor: Colors.grey.shade400,
        ),
        child: Scrollbar(
          thickness: 7.0,
          radius: const Radius.circular(10.0),
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: buildListView(),
          ),
        ),
      ),
      floatingActionButton: (!_showBackToTopButton)
          ? null
          : FloatingActionButton(
              onPressed: () {
                _scrollToTop();
              },
              child: const Icon(Icons.arrow_upward_rounded, color: kbrown),
              backgroundColor: kyellow,
            ),
    );
  }
}
