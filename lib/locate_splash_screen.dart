import 'package:flutter/material.dart';
import 'package:karten/data_center.dart';
import 'package:karten/geocoding_object.dart';
import 'package:karten/main.dart';
import 'package:lottie/lottie.dart';


Datacenter datacenter = Datacenter();
class LocateSplashScreen extends StatefulWidget {
  const LocateSplashScreen({Key? key}) : super(key: key);

  @override
  _LocateSplashScreenState createState() => _LocateSplashScreenState();
}

class _LocateSplashScreenState extends State<LocateSplashScreen> {


  late Future<dynamic> fetchedLocationInfoForSplashScreen;
  GeoCodedAddress geoCodedAddress = GeoCodedAddress();
  late String address;


  getTheCurrentLocationInAddress()
  {
    fetchedLocationInfoForSplashScreen = geoCodedAddress.getAddressFromLatLng();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheCurrentLocationInAddress();
    datacenter.isMinimalMap = true;
  }

  moveToHomePage() async
  {
    await Future.delayed(Duration(milliseconds: 1100));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset("assets/mm2.json",reverse: true,),
                  Lottie.asset("assets/locate_marker_animation.json",height: 180),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 140),
                child: FutureBuilder(
                  future: fetchedLocationInfoForSplashScreen,
                  builder: (context, snapshot)
                  {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return Center(child: const Text("Locating...",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700,fontFamily: "Lato"),));
                        }
                      else if(snapshot.hasData)
                        {
                          address = snapshot.data as String;
                          moveToHomePage();
                          return Center(child: Text(address,style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700,fontFamily: "Lato"),));
                        }
                      else if(snapshot.hasError)
                        {
                          return const Text("Could not find you",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700,fontFamily: "Lato"),);
                        }
                      else
                        {
                          return Container();
                        }
                  },
                ),
              )
            ],
          ),

          Center(child: Text("Setting up karten...",style: TextStyle(color: Colors.grey.shade700,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "Lato"),)),


        ],
      )
    );
  }
}
