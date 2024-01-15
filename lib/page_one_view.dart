import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:karten/data_center.dart';
import 'package:karten/safest_route_computation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'location_set_object.dart';
import 'map_control_object.dart';

import 'package:lottie/lottie.dart' as lot;

import 'locate_splash_screen.dart';


class Page1View extends StatefulWidget {

  late LocationSetObject locationSetObject;

  Page1View({required this.locationSetObject});

  @override
  _Page1ViewState createState() => _Page1ViewState(locationSetObject: locationSetObject);
}

class _Page1ViewState extends State<Page1View> {

  late LocationSetObject locationSetObject;
  _Page1ViewState({required this.locationSetObject});

  late MapControlObject mapControlObject;

  late LatLng startLocationLatLng;
  late LatLng endLocationLatLng;

  bool startLocationSelected = false;
  bool endLocationSelected = false;
  bool canStartJourney = false;

  bool isDistanceCalculated = false;
  late double radiusInMetres;
  String distanceStr = " ";

  Set<Marker> markerSet = {};
  late LatLngBounds mapBounds;

  final Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor customMarkerStart;
  late BitmapDescriptor customMarkerEnd;

  String? _mapStyle;

  setCustomMarkersViaBitMap()
  {
    print("2@@@@@@@@@@@@@@@@@@@@@@");
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.2), 'assets/marker_icon/start_location_marker.png')
        .then((fetchedImage) {
      customMarkerStart = fetchedImage;
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.2), 'assets/marker_icon/end_location_marker.png')
        .then((fetchedImage) {
      customMarkerEnd = fetchedImage;
    });
    print("3@@@@@@@@@@@@@@@@@@@@@@");
  }



  addLocationMarkers(String title, String snippet, String type) async
  {
    if (type == "start")
    {
      startLocationSelected = true;
      startLocationLatLng = locationSetObject.locationDataOfLastPoint;
      markerSet.add(Marker(markerId: MarkerId(locationSetObject.locationDataOfLastPoint.toString()), position: locationSetObject.locationDataOfLastPoint, icon: customMarkerStart, infoWindow: InfoWindow(title: title, snippet: snippet)));

      setState(() {});
    }
    else if (type == "end")
    {
      endLocationSelected = true;
      endLocationLatLng = locationSetObject.locationDataOfLastPoint;
      markerSet.add(Marker(markerId: MarkerId(locationSetObject.locationDataOfLastPoint.toString()), position: locationSetObject.locationDataOfLastPoint, icon: customMarkerEnd, infoWindow: InfoWindow(title: title, snippet: snippet)));
      setState(() {});

      await Future.delayed(const Duration(seconds: 2));

      final GoogleMapController googleMapController = await _controller.future;
      mapControlObject = MapControlObject(googleMapController: googleMapController, startLocationLatLng: startLocationLatLng, endLocationLatLng: endLocationLatLng);
      mapControlObject.setMapBoundsAndAnimate();

      calculateDistanceBetweenLatLng();
    }
  }

  calculateDistanceBetweenLatLng()
  {
    radiusInMetres = Geolocator.distanceBetween(startLocationLatLng.latitude, startLocationLatLng.longitude, endLocationLatLng.latitude, endLocationLatLng.longitude);
    isDistanceCalculated = true;
    if(radiusInMetres<=10000)
    {
      canStartJourney = true;
      if(radiusInMetres>=1000)
      {
        radiusInMetres = radiusInMetres/1000;
        distanceStr = "Approx distance "+radiusInMetres.toStringAsPrecision(1)+" km";
      }
      else
      {
        distanceStr = "Approx distance "+radiusInMetres.toInt().toString()+" m";
      }
    }
    else
    {
      distanceStr = "Can't commute! Distance more than 10 km";
    }


    setState(() {

    });
  }

  removeAddedMarkers() async
  {
    await setCustomMarkersViaBitMap();
    markerSet.clear();
    startLocationSelected = false;
    endLocationSelected = false;
    canStartJourney = false;
    isDistanceCalculated = false;

    setState(() {});

    final GoogleMapController googleMapController = await _controller.future;
    relocateToCurrentLocation(googleMapController);
  }

  void _onMapCreated(GoogleMapController controller)
  {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);
  }

  void relocateToCurrentLocation(GoogleMapController controller) async
  {
    await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(locationSetObject.locationDataOfCurrentUser.latitude!, locationSetObject.locationDataOfCurrentUser.longitude!), 16)).whenComplete(() => print("relocated"));
  }


  void _launchURL(String _url) async
  {
    _url ='https://www.google.com/maps/dir/?api=1&origin=20.001038,73.754816&destination=19.994890,73.777654&waypoints=20.009331,73.766766&travelmode=driving&dir_action=navigate';
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle.loadString(datacenter.isMinimalMap?'assets/map_style.txt':'assets/map_style_default.txt').then((string) {
      _mapStyle = string;
    });

    removeAddedMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(alignment: Alignment.center, children: [
            Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  onCameraMove: (currentLatLngPosition)
                  {
                    print(currentLatLngPosition.target);
                    locationSetObject.locationDataOfLastPoint = currentLatLngPosition.target;
                  },
                  initialCameraPosition: CameraPosition(target: LatLng(locationSetObject.locationDataOfCurrentUser.latitude!, locationSetObject.locationDataOfCurrentUser.longitude!), zoom: 16,),
                  zoomControlsEnabled: false,
                  markers: markerSet,
                  mapToolbarEnabled: false,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 35, right: 35, top: 50),
                    child: Text("Safest route  ", style: TextStyle(color: Colors.black, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 22)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35, right: 35, top: 20),
                    child: Text("Let's navigate with safety. You have 5 commutes left to use!", style: TextStyle(color: Colors.black, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 15),),
                  ),

                ],
              ),
            ]),

            isDistanceCalculated?Container():GestureDetector(child: PointerWidget(
              actionText: startLocationSelected ? endLocationSelected ? " " : "Tap on the marker\nto set end location" : "Tap on the marker\nto set start location",
            ),
              onTap: ()
              {
                startLocationSelected ? endLocationSelected ? print("Done Selecting") : addLocationMarkers("End Location", "Your safety commute will end here", "end") : addLocationMarkers("Start Location", "Your safety commute will start here", "start");
                print("hehehehehehehehe");
              },
            ),

          ]),

          isDistanceCalculated?Padding(
            padding:  EdgeInsets.only(left: 35, right: 35, top: 0,bottom: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(canStartJourney?Colors.black45:Colors.red.shade900),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))))),
                      child: Text(distanceStr, style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                      onPressed: null,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 70,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.cancel_outlined),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black87),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0))))),
                      label: Text("Clear marker",style: const TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w600,fontSize: 14,color: Colors.white),),
                      onPressed: () async {
                        removeAddedMarkers();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 70,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black87),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12))))),
                      label: Text(canStartJourney?"Start journey":"Shortest route",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w600,fontSize: 14,color: Colors.white)),
                      onPressed: () async
                      {
                        canStartJourney?Navigator.of(context).push(MaterialPageRoute(builder: (context) => StartComputationView(START_LOCATION: startLocationLatLng, END_LOCATION: endLocationLatLng),),):_launchURL("");
                        removeAddedMarkers();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ):Container(),

        ],
      ),
    );
  }
}


class PointerWidget extends StatelessWidget {

  String actionText;
  PointerWidget({required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          lot.Lottie.asset("assets/marker_animation.json", height: 110,),
          AnimatedTextKit(repeatForever: true, pause: const Duration(milliseconds: 1000),
            animatedTexts: [
              FadeAnimatedText(actionText,textStyle:const TextStyle(color: Colors.black, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 18,),textAlign: TextAlign.center,duration: const Duration(milliseconds: 4000))
            ],
          )
        ],
      ),
    );
  }
}
