import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControlObject
{
  late LatLngBounds mapBounds;
  LatLng startLocationLatLng;
  LatLng endLocationLatLng;
  GoogleMapController googleMapController;
  MapControlObject({required this.googleMapController,required this.startLocationLatLng,required this.endLocationLatLng});

  setMapBoundsAndAnimate() async
  {
    if (startLocationLatLng.latitude > endLocationLatLng.latitude && startLocationLatLng.longitude > endLocationLatLng.longitude)
    {
      mapBounds = LatLngBounds(southwest: endLocationLatLng, northeast: startLocationLatLng);
    }
    else if (startLocationLatLng.longitude > endLocationLatLng.longitude)
    {
      mapBounds = LatLngBounds(southwest: LatLng(startLocationLatLng.latitude, endLocationLatLng.longitude), northeast: LatLng(endLocationLatLng.latitude, startLocationLatLng.longitude));
    }
    else if (startLocationLatLng.latitude > endLocationLatLng.latitude)
    {
      mapBounds = LatLngBounds(southwest: LatLng(endLocationLatLng.latitude, startLocationLatLng.longitude), northeast: LatLng(startLocationLatLng.latitude, endLocationLatLng.longitude));
    }
    else
    {
      mapBounds = LatLngBounds(southwest: startLocationLatLng, northeast: endLocationLatLng);
    }

    await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(mapBounds, 100))
        .then((value) {
    });

  }




}