import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:karten/location_set_object.dart';
import 'package:location/location.dart';

class LocationServices
{
  Location location = Location();
  late LocationData locationData;
  late LocationSetObject locationSetObject;

  Future<LocationSetObject> getCurrentLocationOfUser() async
  {
    locationData = await location.getLocation();
    print(locationData);
    locationSetObject = LocationSetObject(locationDataOfCurrentUser: locationData, locationDataOfLastPoint: LatLng(locationData.latitude!,locationData.longitude!), isLocationRetrieved: true);

    return locationSetObject;
  }
}