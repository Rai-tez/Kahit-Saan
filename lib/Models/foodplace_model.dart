
/*
* I HATE THIS SPECIFIC FILE WITH A PASSION -Andrei
*
* Please refer to example Json1 and example json 2 in the Project
* for a better understanding of the hierarchy/tree/classes below
*
* WARNING: DO NOT CHANGE ANYTHING UNLESS ITS FIXING SOMETHING I HATE THIS FILE :)
*
* // HIERARCHY:
*
*   FoodPlace{
*     Results{
*       String name;
*       String place_id;
*       String? vicinity;
*       String? rating;
*       String? user_ratings_total;
*       List<String> types;
*       String? price_level;
*       Geometry{
*         RestoLocation{
*           double latitude;
*           double longitude;
*         }
*       };
*       Photos{
*         String photo_reference;
*       };
*     }
*   }
* // END OF HIERARCHY
* */

//outermost layer in json or root
class FoodPlace{
  List<Results> results;

  FoodPlace({
    required this.results,
  });

  ///json to List<Results> converter
  factory FoodPlace.fromJson(Map<String, dynamic> json){
    return FoodPlace(
        results: json["results"].toList(),
    );
  }

}

/// descendants of Foodplace
class Results{

  // children of Results

  ///name of eatery
  String name;

  ///unique identifier of the eatery
  String place_id;

  ///address of the eatery, will return null or "" if not specified in the json
  String? vicinity;

  ///contains latitude[double] and longitude[double] coordinates of the eatery
  Geometry geometry;

  ///list of photos which are list of [String] that are references to the photos
  List<dynamic> photos;

  ///ratings of a certain eatery ranging from 0 - 5
  ///if there are no ratings, string is null
  String? rating;

  ///number of ratings received by the restaurant
  ///if there are no ratings, string is null
  String? user_ratings_total;

  ///this shows the price level of the resto ranging from 0(free) - 5(expensive)
  ///can be null if price level is not specified in the json
  String? price_level;

  Results({
    required this.name,
    required this.place_id,
    required this.geometry,
    required this.vicinity,
    required this.photos,
    this.price_level,
    this.user_ratings_total,
    this.rating
  });

  ///json to Results converter
  factory Results.fromJson(Map<String, dynamic> json){
    return Results(
      name:                 json["name"],
      place_id:             json["place_id"],
      geometry:             Geometry.fromJson(json["geometry"]),
      vicinity:            (json["vicinity"]!= null || json["vicinity"] != "")? json["vicinity"] : "vicinity unknown",
      photos:              (json["photos"]!= null)? json["photos"].toList(): [],
      user_ratings_total:  (json["user_ratings_total"]!= null) ? json["user_ratings_total"].toString() : "No Ratings",
      price_level:         (json["price_level"] != null) ? json["price_level"].toString() : "Unknown",
      rating:              (json["rating"] != null) ?  json["rating"].toString() : "No ratings"
    );
  }
}

class Geometry{

  ///contains latitude[double] and longitude[double] coordinates of the eatery
  RestoLocation location;

  Geometry({required this.location});

  ///json to location converter
  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      location: RestoLocation.fromJson(json["location"]),
    );
  }

}

class RestoLocation{
  double lat;
  double lng;

  RestoLocation({required this.lat, required this.lng});

  ///json to latitude longitude converter
  factory RestoLocation.fromJson(Map<String, dynamic> json){
    return RestoLocation(
      lat: json["lat"] as double,
      lng: json["lng"] as double,
    );
  }

}

class Photos{
  ///gets a string of a photo reference that is associated with the eatery
  String photo_reference;

  Photos({required this.photo_reference});

  factory Photos.fromJson(Map<String, dynamic> json){
    return Photos(
      photo_reference:
      (json["photo_reference"].isNotEmpty || json["photo_reference"] != null)
          ? json["photo_reference"] : "No Photos"
    );
  }
}
