import 'package:geocoding/geocoding.dart';
import 'package:karten/location_set_object.dart';

import 'location_services.dart';

class GeoCodedAddress
{
  late LocationSetObject locationData;

  LocationServices locationServices = LocationServices();
  String address = " ";


  Future<String> getAddressFromLatLng() async
  {
    try
    {
      locationData = await locationServices.getCurrentLocationOfUser();
      print(locationData);
      List<Placemark> placemarks = await placemarkFromCoordinates(locationData.locationDataOfCurrentUser.latitude!, locationData.locationDataOfCurrentUser.longitude!);
      Placemark place = placemarks[0];
      address = place.locality!+", "+place.country!;
    }
    catch (e)
    {
      print(e);
    }

    Future.delayed(const Duration(milliseconds: 2700));

    return address;
  }
}