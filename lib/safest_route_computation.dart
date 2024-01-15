import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:karten/safer.dart';
import 'package:karten/safest_route_loading_view.dart';
import 'package:karten/way_point_check_poin_object.dart';


class StartComputationView extends StatefulWidget {
  LatLng START_LOCATION;
  LatLng END_LOCATION;
  StartComputationView({required this.START_LOCATION,required this.END_LOCATION});

  @override
  _StartComputationViewState createState() => _StartComputationViewState(START_LOCATION: START_LOCATION,END_LOCATION: END_LOCATION);
}

class _StartComputationViewState extends State<StartComputationView> {
  LatLng START_LOCATION;
  LatLng END_LOCATION;
  _StartComputationViewState({required this.START_LOCATION,required this.END_LOCATION});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SafestRouteComputation safestRouteComputation = SafestRouteComputation(START_LOCATION: START_LOCATION, END_LOCATION: END_LOCATION, context: context);
    safestRouteComputation.callTheDirectionAPI();
  }
  @override
  Widget build(BuildContext context) {
    return const SafestRouteLoadingView();
  }
}


class SafestRouteComputation
{
  LatLng START_LOCATION;
  LatLng END_LOCATION;
  BuildContext context;
  SafestRouteComputation({required this.START_LOCATION,required this.END_LOCATION,required this.context});


  //key to be encrypted

  String KEY_DIRECTION_API = "&key=AIzaSyBVDr_HwsChsx2PifFV0RUbIb9oTSnf13Q";

  List<dynamic>? ROUTES;
  List<dynamic>? STEPS;

  String? STATUS;
  int? NUMBER_OF_STEPS;

  late LatLng NORTH_EAST_BOUND;
  late LatLng SOUTH_WEST_BOUND;
  late LatLngBounds COMPLETE_MAP_BOUND;

  late String START_ADDRESS;
  late String END_ADDRESS;

  String? COMPLETE_DURATION;
  int? COMPLETE_DISTANCE;

  late int ACCURACY;

  List<String> ENCODED_POLYLINES_LIST = [];
  List<LatLng> COMPLETE_JOURNEY_LAT_LNG = [];
  List<List<int>> START_AND_END_INDEXES = [];
  List<int> INDEXES_LIST_FOR_SCORE = [];

  PolylinePoints POLYLINE_POINTS = PolylinePoints();

  late BitmapDescriptor customMarkerSafety;

  int SCORES_FOR_SAFETY = 0;
  int SCORE_FOR_POLICE = 100;
  int SCORE_FOR_MEDICAL = 50;
  int SCORE_FOR_ATM = 20;
  int SCORE_FOR_GAS_STATION = 30;


  String BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?opennow=true";
  String KEY = "AIzaSyBJQcJHahFxYintO8pPPI7KkKnOaS7DwJM";
  String BASE_URL_FOR_NAVIGATION = "https://www.google.com/maps/dir/?api=1";

  Set<Marker> MARKER_SET = {};
  Set<Polyline> POLY_LINE_SET = {};

  List<WayPointCheckPoint> WAYPOINT_CHECK_POINT_LIST = [];
  List<LatLng> WAYPOINTS = [];


  void callTheDirectionAPI() async
  {
    String START_LOCATION_STR = START_LOCATION.latitude.toString()+","+START_LOCATION.longitude.toString();
    String END_LOCATION_STR = END_LOCATION.latitude.toString()+","+END_LOCATION.longitude.toString();

    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/directions/json?origin="+START_LOCATION_STR+"&destination="+END_LOCATION_STR+KEY_DIRECTION_API);

    Response responseOfDirectionAPI = await get(uri);
    Map<String,dynamic> responseToMap = jsonDecode(responseOfDirectionAPI.body);
    if(responseToMap["status"]=="OK")
      {
        ROUTES = responseToMap["routes"];
        setParameterValues();
      }

    //code for no routes condition as well as error page
  }

  setParameterValues() async
  {
    setCustomMarkersViaBitMap();

    STEPS = ROUTES![0]["legs"][0]["steps"];
    NUMBER_OF_STEPS = STEPS!.length;

    NORTH_EAST_BOUND = LatLng(ROUTES![0]["bounds"]["northeast"]["lat"] as double, ROUTES![0]["bounds"]["northeast"]["lng"] as double);
    SOUTH_WEST_BOUND = LatLng(ROUTES![0]["bounds"]["southwest"]["lat"] as double, ROUTES![0]["bounds"]["southwest"]["lng"] as double);
    COMPLETE_MAP_BOUND = LatLngBounds(southwest: SOUTH_WEST_BOUND, northeast: NORTH_EAST_BOUND);


    START_ADDRESS = ROUTES![0]["legs"][0]["start_address"] as String;
    END_ADDRESS = ROUTES![0]["legs"][0]["end_address"] as String;

    COMPLETE_DURATION = ROUTES![0]["legs"][0]["duration"]["text"] as String;
    COMPLETE_DISTANCE = ROUTES![0]["legs"][0]["distance"]["value"];

    ACCURACY = (COMPLETE_DISTANCE! > 8000?1000:COMPLETE_DISTANCE!<5000?500:700);

    setDecodedPolylinesToList();
  }

  setCustomMarkersViaBitMap()
  {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 1.2), 'assets/marker_icon/circle4.png')
        .then((fetchedImage) {
      customMarkerSafety = fetchedImage;
    });
  }

  void setDecodedPolylinesToList()
  {
    for (int i = 0; i < NUMBER_OF_STEPS!; i++)
    {
      ENCODED_POLYLINES_LIST.add(STEPS![i]["polyline"]["points"] as String);
    }


    for(int i = 0; i < NUMBER_OF_STEPS!; i++)
    {
      if(ENCODED_POLYLINES_LIST.isNotEmpty)
      {
        List<PointLatLng> TEMP_POINT_LAT_LNG_LIST = POLYLINE_POINTS.decodePolyline(ENCODED_POLYLINES_LIST[i]);
        for(int j = 0; j < TEMP_POINT_LAT_LNG_LIST.length; j++)
        {
          COMPLETE_JOURNEY_LAT_LNG.add(LatLng(TEMP_POINT_LAT_LNG_LIST.asMap()[j]!.latitude, TEMP_POINT_LAT_LNG_LIST.asMap()[j]!.longitude));
        }
      }
    }

    classifyLatLngIndexes();

  }

  void checkForPlacesNearby() async
  {
    for(int i=1;i<INDEXES_LIST_FOR_SCORE.length;i++)
    {
      await Future.wait([findPoliceCloseToLatLng(COMPLETE_JOURNEY_LAT_LNG[INDEXES_LIST_FOR_SCORE[i]],i),
        findMedicalCloseToLatLng(COMPLETE_JOURNEY_LAT_LNG[INDEXES_LIST_FOR_SCORE[i]],i),
        findGasStationCloseToLatLng(COMPLETE_JOURNEY_LAT_LNG[INDEXES_LIST_FOR_SCORE[i]],i),
        findATMCloseToLatLng(COMPLETE_JOURNEY_LAT_LNG[INDEXES_LIST_FOR_SCORE[i]],i)],).then(
              (List r) => (){}
      );

      createPolyLinesSet(i);

      SCORES_FOR_SAFETY<150?setWayPointsForSafestRoute():(){};
      SCORES_FOR_SAFETY = 0;

    }

    safestRouteURLBuilder();
  }


  void classifyLatLngIndexes()
  {
    double distanceInMeters = 0.0;
    for (int i = 0; i < COMPLETE_JOURNEY_LAT_LNG.length;i++)
    {
      for (int j = i; j < COMPLETE_JOURNEY_LAT_LNG.length; j++)
      {
        distanceInMeters = Geolocator.distanceBetween(COMPLETE_JOURNEY_LAT_LNG[i].latitude, COMPLETE_JOURNEY_LAT_LNG[i].longitude, COMPLETE_JOURNEY_LAT_LNG[j].latitude, COMPLETE_JOURNEY_LAT_LNG[j].longitude);
        if(distanceInMeters >= ACCURACY)
        {
          START_AND_END_INDEXES.add([i,j]);
          i = j;
        }
        else if (distanceInMeters < ACCURACY)
        {
          continue;
        }
      }
    }


    START_AND_END_INDEXES.add([START_AND_END_INDEXES.last[1],COMPLETE_JOURNEY_LAT_LNG.length-1]);

    for(int i=0;i<START_AND_END_INDEXES.length;i = i+2)
    {
      INDEXES_LIST_FOR_SCORE.add(START_AND_END_INDEXES[i][1]);
    }

    START_AND_END_INDEXES.length%2==0?INDEXES_LIST_FOR_SCORE.add(START_AND_END_INDEXES.last[1]):(){};
    INDEXES_LIST_FOR_SCORE.insert(0, 0);

    checkForPlacesNearby();
  }


  String urlBuilderForURI(String keyword, LatLng location, int radius, String type)
  {
    String url = BASE_URL+"&keyword="+keyword+"&location="+location.latitude.toString()+","+location.longitude.toString()+"&radius="+radius.toString()+"&type="+type+"&key="+KEY;
    return url;
  }


  Future<bool> findPoliceCloseToLatLng(LatLng locationOfCheckPoint, int index) async
  {
    Uri uriForPolice = Uri.parse(urlBuilderForURI("police+station", locationOfCheckPoint, ACCURACY, "police"));
    Response responseForPolice = await get(uriForPolice);
    Map<String, dynamic> dataOfPolice = jsonDecode(responseForPolice.body);

    if(dataOfPolice["status"]=="OK")
    {
      SCORES_FOR_SAFETY = SCORES_FOR_SAFETY + (SCORE_FOR_POLICE * dataOfPolice["results"].length as int);
      int indexOfResult = 0;
      double minimumDistancePolice = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfPolice["results"][0]["geometry"]["location"]["lat"], dataOfPolice["results"][0]["geometry"]["location"]["lng"]);

      for(int i = 0; i<dataOfPolice["results"].length; i++)
      {
        double distanceTemp = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfPolice["results"][i]["geometry"]["location"]["lat"], dataOfPolice["results"][i]["geometry"]["location"]["lng"]);
        if(distanceTemp  < minimumDistancePolice)
        {
          minimumDistancePolice = distanceTemp ;
          indexOfResult = i;
        }
        MARKER_SET.add(Marker(markerId: MarkerId(dataOfPolice["results"][i]["name"]),position: LatLng(dataOfPolice["results"][indexOfResult]["geometry"]["location"]["lat"],dataOfPolice["results"][indexOfResult]["geometry"]["location"]["lng"]),icon: customMarkerSafety,infoWindow: InfoWindow(title: dataOfPolice["results"][indexOfResult]["name"],snippet: " ")));
      }

      LatLng latLngOfPlace = LatLng(dataOfPolice["results"][indexOfResult]["geometry"]["location"]["lat"] as double, dataOfPolice["results"][indexOfResult]["geometry"]["location"]["lng"] as double);
      WayPointCheckPoint wayPointCheckPoint = WayPointCheckPoint(location_of_place: latLngOfPlace, name_of_place: dataOfPolice["results"][indexOfResult]["name"], place_id: dataOfPolice["results"][indexOfResult]["place_id"], minimum_distance: minimumDistancePolice);
      WAYPOINT_CHECK_POINT_LIST.add(wayPointCheckPoint);
      print("+++++"+minimumDistancePolice.toString());
    }


    else if(dataOfPolice["status"] == "ZERO_RESULTS")
    {
      print("ZERO");
    }
    else
    {
      print("ERORr");
    }

    print(index.toString()+" "+SCORES_FOR_SAFETY.toString()+" 0");
    return true;

  }

  Future<bool> findMedicalCloseToLatLng(LatLng locationOfCheckPoint, int index) async
  {
    Uri uriForMedical = Uri.parse(urlBuilderForURI("medical", locationOfCheckPoint, 200, "medical"));
    Response responseForMedical = await get(uriForMedical);
    Map<String, dynamic> dataOfMedical = jsonDecode(responseForMedical.body);

    if(dataOfMedical["status"]=="OK")
    {
      SCORES_FOR_SAFETY = SCORES_FOR_SAFETY + (SCORE_FOR_MEDICAL * dataOfMedical["results"].length as int);
      int indexOfResult = 0;
      double minimumDistanceMedical = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfMedical["results"][0]["geometry"]["location"]["lat"], dataOfMedical["results"][0]["geometry"]["location"]["lng"]);

      for(int i =0 ;i<dataOfMedical["results"].length;i++)
      {
        double distanceTemp = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfMedical["results"][i]["geometry"]["location"]["lat"], dataOfMedical["results"][i]["geometry"]["location"]["lng"]);
        if(distanceTemp  < minimumDistanceMedical)
        {
          minimumDistanceMedical = distanceTemp ;
          indexOfResult = i;
        }
        MARKER_SET.add(Marker(markerId: MarkerId(dataOfMedical["results"][i]["name"]),position: LatLng(dataOfMedical["results"][indexOfResult]["geometry"]["location"]["lat"],dataOfMedical["results"][indexOfResult]["geometry"]["location"]["lng"]),icon: customMarkerSafety,infoWindow: InfoWindow(title: dataOfMedical["results"][indexOfResult]["name"],snippet: " ")));
      }
    }


    else if(dataOfMedical["status"] == "ZERO_RESULTS")
    {
      print("ZERO");
    }
    else
    {
      print("ERORr");
    }

    print(index.toString()+" "+SCORES_FOR_SAFETY.toString()+" 1");
    return true;

  }

  Future<bool> findGasStationCloseToLatLng(LatLng locationOfCheckPoint, int index) async
  {
    Uri uriForGasStation = Uri.parse(urlBuilderForURI("petrol+pump", locationOfCheckPoint, 300, "gas_station"));
    Response responseForGasStation = await get(uriForGasStation);
    Map<String, dynamic> dataOfGasStation = jsonDecode(responseForGasStation.body);

    if(dataOfGasStation["status"]=="OK")
    {
      SCORES_FOR_SAFETY = SCORES_FOR_SAFETY + (SCORE_FOR_GAS_STATION * dataOfGasStation["results"].length as int);
      int indexOfResult = 0;
      double minimumDistanceGasStation = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfGasStation["results"][0]["geometry"]["location"]["lat"], dataOfGasStation["results"][0]["geometry"]["location"]["lng"]);

      for(int i = 0;i<dataOfGasStation["results"].length;i++)
      {
        double distanceTemp = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfGasStation["results"][i]["geometry"]["location"]["lat"], dataOfGasStation["results"][i]["geometry"]["location"]["lng"]);
        if(distanceTemp  < minimumDistanceGasStation)
        {
          minimumDistanceGasStation = distanceTemp ;
          indexOfResult = i;
        }
        MARKER_SET.add(Marker(markerId: MarkerId(dataOfGasStation["results"][i]["name"]),position: LatLng(dataOfGasStation["results"][indexOfResult]["geometry"]["location"]["lat"],dataOfGasStation["results"][indexOfResult]["geometry"]["location"]["lng"]),icon: customMarkerSafety,infoWindow: InfoWindow(title: dataOfGasStation["results"][indexOfResult]["name"],snippet: " ")));
      }

      LatLng latLngOfPlace = LatLng(dataOfGasStation["results"][indexOfResult]["geometry"]["location"]["lat"] as double, dataOfGasStation["results"][indexOfResult]["geometry"]["location"]["lng"] as double);
      WayPointCheckPoint wayPointCheckPoint = WayPointCheckPoint(location_of_place: latLngOfPlace, name_of_place: dataOfGasStation["results"][indexOfResult]["name"], place_id: dataOfGasStation["results"][indexOfResult]["place_id"],minimum_distance: minimumDistanceGasStation);
      print("+++++++"+minimumDistanceGasStation.toString());
      WAYPOINT_CHECK_POINT_LIST.add(wayPointCheckPoint);

    }


    else if(dataOfGasStation["status"] == "ZERO_RESULTS")
    {
      print("ZERO");
    }
    else
    {
      print("ERORr");
    }

    print(index.toString()+" "+SCORES_FOR_SAFETY.toString()+" 2");

    return true;

  }

  Future<bool> findATMCloseToLatLng(LatLng locationOfCheckPoint, int index) async
  {
    Uri uriForATM = Uri.parse(urlBuilderForURI("atm", locationOfCheckPoint, 200, "atm"));
    Response responseForATM = await get(uriForATM);
    Map<String, dynamic> dataOfATM = jsonDecode(responseForATM.body);

    if(dataOfATM["status"]=="OK")
    {
      SCORES_FOR_SAFETY = SCORES_FOR_SAFETY + (SCORE_FOR_ATM * dataOfATM["results"].length as int);
      int indexOfResult = 0;
      double minimumDistanceATM = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfATM["results"][0]["geometry"]["location"]["lat"], dataOfATM["results"][0]["geometry"]["location"]["lng"]);

      for(int i =0 ;i<dataOfATM["results"].length;i++)
      {
        double distanceTemp = Geolocator.distanceBetween(locationOfCheckPoint.latitude, locationOfCheckPoint.longitude, dataOfATM["results"][i]["geometry"]["location"]["lat"], dataOfATM["results"][i]["geometry"]["location"]["lng"]);
        if(distanceTemp  < minimumDistanceATM)
        {
          minimumDistanceATM = distanceTemp ;
          indexOfResult = i;
        }
        MARKER_SET.add(Marker(markerId: MarkerId(dataOfATM["results"][i]["name"]),position: LatLng(dataOfATM["results"][indexOfResult]["geometry"]["location"]["lat"],dataOfATM["results"][indexOfResult]["geometry"]["location"]["lng"]),icon: customMarkerSafety,infoWindow: InfoWindow(title: dataOfATM["results"][indexOfResult]["name"],snippet: " ")));
      }
    }


    else if(dataOfATM["status"] == "ZERO_RESULTS")
    {
      print("ZERO");
    }
    else
    {
      print("ERORr");
    }

    print(index.toString()+" "+SCORES_FOR_SAFETY.toString()+" 3");
    return true;

  }

  Color setColorBasedOnScore()
  {
    late Color color;
    if(SCORES_FOR_SAFETY<50)
    {
      color = const Color(0xff720714);
    }
    else if(SCORES_FOR_SAFETY>=50 && SCORES_FOR_SAFETY<=100)
    {
      color = const Color(0xffb43307);
    }
    else if(SCORES_FOR_SAFETY>100 && SCORES_FOR_SAFETY<=150)
    {
      color = const Color(0xffce5403);
    }
    else if(SCORES_FOR_SAFETY>150 && SCORES_FOR_SAFETY < 200)
    {
      color = const Color(0xffbfa805);
    }
    else if(SCORES_FOR_SAFETY>=200 && SCORES_FOR_SAFETY < 250)
    {
      color = const Color(0xff58a01f);
    }
    else if(SCORES_FOR_SAFETY>=250)
    {
      color = const Color(0xff447c45);
    }
    return color;
  }


  void createPolyLinesSet(int index)
  {
    print(INDEXES_LIST_FOR_SCORE);
    List<LatLng> tempList = [];
    for(int i= INDEXES_LIST_FOR_SCORE[index-1];i<=INDEXES_LIST_FOR_SCORE[index];i++)
    {
      tempList.add(COMPLETE_JOURNEY_LAT_LNG[i]);
    }
    print(tempList.length);
    POLY_LINE_SET.add(Polyline(polylineId: PolylineId(index.toString()),points:tempList,color: setColorBasedOnScore(),width: 10,jointType: JointType.mitered,startCap: Cap.roundCap,endCap: Cap.roundCap));
  }

  void setWayPointsForSafestRoute()
  {
    if(WAYPOINT_CHECK_POINT_LIST.isNotEmpty)
    {
      double minimum_distance_between_points = WAYPOINT_CHECK_POINT_LIST[0].minimum_distance;
      print("DOUBLE DIS  "+minimum_distance_between_points.toString());
      for(int i = 0; i<WAYPOINT_CHECK_POINT_LIST.length;i++)
      {
        if(WAYPOINT_CHECK_POINT_LIST[i].minimum_distance<=minimum_distance_between_points)
        {
          minimum_distance_between_points = WAYPOINT_CHECK_POINT_LIST[i].minimum_distance;
          print("way point added "+minimum_distance_between_points.toString());
          WAYPOINTS.add(WAYPOINT_CHECK_POINT_LIST[i].location_of_place);
        }
      }
      WAYPOINT_CHECK_POINT_LIST = [];
    }
    // accuracy buff to 78 per
  }

  void safestRouteURLBuilder()
  {
    String origin = "&origin="+START_LOCATION.latitude.toString()+","+START_LOCATION.longitude.toString();
    String destination = "&destination="+END_LOCATION.latitude.toString()+","+END_LOCATION.longitude.toString();
    String waypoints = "&waypoints=";
    for(int i=0;i<WAYPOINTS.length;i++)
    {
      waypoints = waypoints+WAYPOINTS[i].latitude.toString()+","+WAYPOINTS[i].longitude.toString()+"|";
    }
    BASE_URL_FOR_NAVIGATION = BASE_URL_FOR_NAVIGATION + origin + destination + waypoints;
    BASE_URL_FOR_NAVIGATION = BASE_URL_FOR_NAVIGATION + "&travelmode=driving&dir_action=navigate";
    print(BASE_URL_FOR_NAVIGATION);




    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SafetyOfShortestRoutePage(polySet: POLY_LINE_SET,markerSet: MARKER_SET,startLocation: START_LOCATION,endLocation: END_LOCATION,mapBounds:COMPLETE_MAP_BOUND,safestRouteUrl: BASE_URL_FOR_NAVIGATION,),),);
    //BASE_URL_FOR_NAVIGATION = "https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate";
  }

}