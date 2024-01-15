import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationSetObject
{
  LocationData locationDataOfCurrentUser;
  LatLng locationDataOfLastPoint;
  bool isLocationRetrieved;

  LocationSetObject({required this.locationDataOfCurrentUser,required this.locationDataOfLastPoint,required this.isLocationRetrieved});
}