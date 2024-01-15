import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karten/location_services.dart';
import 'package:karten/location_set_object.dart';
import 'package:karten/page_one_view.dart';
import 'package:lottie/lottie.dart' as lot;



class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  _Page1State createState() => _Page1State();
}



class _Page1State extends State<Page1> {

  LocationServices locationServices = LocationServices();
  late LocationSetObject _locationSetObject;
  late Future<dynamic> fetchedLocationInfo;


  getCurrentLocationOfUser()
  {
    //Future returning locationData from location Services
    fetchedLocationInfo = locationServices.getCurrentLocationOfUser();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //call to get Location from location services
    getCurrentLocationOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedLocationInfo,
      builder: (context,snapshot)
      {
        if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: lot.Lottie.asset("assets/marker_animation.json", height: 110,));
          }
        else if(snapshot.hasData)
          {
            _locationSetObject = snapshot.data as LocationSetObject;
            print(_locationSetObject);
            return Page1View(locationSetObject: _locationSetObject,);
          }
        else if(snapshot.hasError)
          {
            return Container(color: Colors.red,);
          }
        else
        {
          return Container(color: Colors.blue,);
        }
      },
    );
  }
}






