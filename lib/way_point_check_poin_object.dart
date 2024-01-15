import 'package:google_maps_flutter/google_maps_flutter.dart';

class WayPointCheckPoint
{
  LatLng location_of_place;
  String name_of_place;
  String place_id;
  double minimum_distance;

  WayPointCheckPoint({required this.location_of_place,required this.name_of_place,required this.place_id, required this.minimum_distance});
}
