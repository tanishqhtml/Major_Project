import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';


class SafetyOfShortestRoutePage extends StatefulWidget {
  Set<Polyline> polySet;
  Set<Marker> markerSet;
  LatLng startLocation;
  LatLng endLocation;
  LatLngBounds mapBounds;
  String safestRouteUrl;
  SafetyOfShortestRoutePage({required this.polySet,required this.markerSet,required this.startLocation,required this.endLocation,required this.mapBounds,required this.safestRouteUrl});

  @override
  _SafetyOfShortestRoutePageState createState() => _SafetyOfShortestRoutePageState(polySet: polySet,markerSet: markerSet,startLocation: startLocation,endLocation: endLocation,mapBounds: mapBounds,safestRouteUrl: safestRouteUrl);
}

class _SafetyOfShortestRoutePageState extends State<SafetyOfShortestRoutePage> {
  Set<Polyline> polySet;
  Set<Marker> markerSet;
  LatLng startLocation;
  LatLng endLocation;
  LatLngBounds mapBounds;
  String safestRouteUrl;
  _SafetyOfShortestRoutePageState({required this.polySet,required this.markerSet,required this.startLocation,required this.endLocation,required this.mapBounds,required this.safestRouteUrl});

  Completer<GoogleMapController> _controller = Completer();
  String? _mapStyle;

  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> pol = {};
  Set<Circle> ccl = {};
  void _onMapCreated(GoogleMapController controller) async
  {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);

    await Future.delayed(const Duration(seconds: 2));

    final GoogleMapController googleMapController = await _controller.future;
    await googleMapController.animateCamera(CameraUpdate.newLatLngBounds(mapBounds, 30))
        .then((value) {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/map_style_2.txt').then((string) {
      _mapStyle = string;
    });
    List<String> p = ["yb`yBsueaMw@A","qd`yBuueaMHrCB~B?dAFpB@vAHdDLnDZzEXzEZbF@HHjA","c``yBibdaMBVWDC?u@H{AHe@?W?oAGwES{CGiAAGAmCKiCM}BKwBKK?aAAeC@}A@q@?qAA}@EA@A??@A?A?A?A?A?A?AAA??AiBI}BM{@EwAG}BOA?_DQI?uAMsASA?yAa@GACAkAWgAUICI?OGA?A@A?A??@A?A?A??AA?A?AAA??AAAOHM@mBOmCS{BQmCS{BO","_rcyBsldaMBl@?P?V?V?z@ChBGxCIlHE~DCdEChG"];
    List<Color> c = [Colors.green,Colors.green,Color(0xff720714),Color(0xff447c45)];
    // for(int i = 0;i<4;i++)
    //   {
    //     addPol(p[i], c[i]);
    //   }
    //addPol("}kayB}edaMMr@t@@~DNtKd@hFLfHT~@?vAI`@m@R]o@mJc@yH_@gJMeMKsEOqJ?mT?gELuGLaFEU?KHSCw@Mw@cAwDREpC_@AoBB{ABgB?_Ef@wEBYIu@EU", Colors.red);
    //addPol("ae`yBmpgaMEM?G?E?E@EFMAg@AOCQIe@cAwD", Colors.white);
  }
  
  addPol(String ppl, Color color){
    List<LatLng> lt =[] ;
    List<PointLatLng> result = polylinePoints.decodePolyline(ppl);
    print("8888888888888888888888888888888888");
    print(result.asMap().length);
    for(int i = 0; i<result.asMap().length; i++)
      {
        lt.add(LatLng(result.asMap()[i]!.latitude, result.asMap()[i]!.longitude));
      }
    print(lt);
    pol.add(Polyline(polylineId: PolylineId("1"),color: color,points:lt,
    width: 10,
    consumeTapEvents: true,
    onTap: ()
    {
      print("7877887878878777777777777777777777777777777777777777777777777777777");
    },
    jointType: JointType.mitered,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,

    ));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        toolbarHeight: 75,
        title: Text("Safety of your route!",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700),),
        automaticallyImplyLeading: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero,bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
      ),
      body: SlidingUpPanel(
        panel: Center(child: CommutePanelView(navi_url: safestRouteUrl,),),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: startLocation, zoom: 15,),
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          polylines: polySet,
          markers: markerSet,
          onCameraIdle: ()async{
          },
        ),
        collapsed: Center(child: Column(
          children: [
            Icon(Icons.minimize_rounded,color: Colors.white,size: 50,),
            Text("Slide up to commute", style: TextStyle(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),),
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) ),
        backdropOpacity: 0.3,
        backdropEnabled: true,
        maxHeight: MediaQuery.of(context).size.height/1.75,
      )
    );
  }
}

class CommutePanelView extends StatelessWidget {
  String navi_url;
  CommutePanelView({required this.navi_url});

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding:  EdgeInsets.only(left: 35, right: 35, top:100),
          child: Text("Color codes fo safety", style: TextStyle(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 18)),
        ),

        ColorCodeInfoWidget(),

        const Padding(
          padding:  EdgeInsets.only(left: 35, right: 35, top:30),
          child: Text("Set transit mode", style: TextStyle(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 18)),
        ),

        Padding(
          padding:  const EdgeInsets.only(left: 35, right: 35, top:10),
          child: ToggleSwitch(
            initialLabelIndex: 0,
            totalSwitches: 3,
            minHeight: 50,
            cornerRadius: 12,
            activeBgColor: const [Colors.blue],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey[800],
            inactiveFgColor: Colors.white60,
            icons: const [Icons.directions_car_filled_rounded,Icons.directions_walk_rounded,Icons.directions_bike_rounded],
            iconSize: 30,
            onToggle: (index){
              print(index);
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 35, right: 35, top: 30),
          child: SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width - 70,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[800]),elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
              child: Text("Tap to commute safely", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Lato", fontWeight: FontWeight.w700),),
              onPressed: () async {
                _launchURL(navi_url);
                print(navi_url);
              },
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 35, right: 35, top:15),
          child: Text("© Karten powered by google maps", style: TextStyle(color: Colors.white, fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 14)),
        ),

      ],
    );
  }
}

class ColorCodeInfoWidget extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 35, right: 35, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width/4,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff447c45)),elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
              child: Text("Safe", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w700),),
              onPressed: null,
            ),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width/4,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffde9e36)),elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
              child: Text("Fair", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w700),),
              onPressed: null,
            ),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width/4,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff720714)),elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
              child: Text("Risky", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w700),),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}


