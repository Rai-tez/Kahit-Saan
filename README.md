# "kahit_saan" for the Final Academic project on CS26011(Mobile Programming) A.Y.2020-2021

DEVELOPERS:
- [Jasmine Joy Lam](https://www.linkedin.com/in/jasminejoylam/)
- [John Angelo Algarne](https://www.linkedin.com/in/john-angelo-algarne-26b3121b2/)
- [Leira Marie Teodoro](https://www.linkedin.com/in/leiramarieteodoro31/)
- [Lester John Quilaman](https://link-url-here.org)
- [Ralph Andrei Benitez](https://www.linkedin.com/in/ralph-andrei-benitez-b08419236/)

> "Saan mo gusto kumain??"
> "Kahit saan nalang"

"Kahit saan" is a phrase indecisive Filipinos usually say when asked on where restaurant to dine 
so our team developed an app based on this. Our application detects nearby food related places to help in
deciding an eatery to settle for(factors include distance, price level, and user rating).


API: https://pub.dev/packages/google_maps_flutter

IMPORTS:
- import 'package:geolocator/geolocator.dart';
- import 'package:sliding_up_panel/sliding_up_panel.dart';
- import 'package:google_maps_flutter/google_maps_flutter.dart';
- import 'package:google_place/google_place.dart';
- import 'package:http/http.dart';

* Setting up google maps *

Requirements:
- Dart SDK version must be updated            // check if entering dependency for google map will say errors
- minSdkVersion: 20                           // check app/build.gradle, needed for google maps
- compileSdkVersion 31                        // check app/build.gradle, compile sdk needs to be 30 above
- API KEY(from google platforms)              

Setting up google maps:
> https://pub.dev/packages/google_maps_flutter

////////if dart sdk is 2.13 and lower, do steps below: ////////
Steps for flutter and dart upgrade:
> https://stackoverflow.com/questions/65602656/the-current-dart-sdk-version-is-2-10-4-how-can-i-change-the-version-into-a-uppe

//If there are any issues, refer to the links below:

// if SDK is not found
- https://stackoverflow.com/questions/49175231/flutter-does-not-find-android-sdk

// cmdline missing
-https://stackoverflow.com/questions/68236007/i-am-getting-this-errors-cmdline-tools-component-is-missing-after-installing-f

//////// end of do steps below ////////



