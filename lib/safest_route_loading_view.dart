import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SafestRouteLoadingView extends StatelessWidget {
  const SafestRouteLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Wait! calculating safety...",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700,fontFamily: "Lato"),),

              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.network("https://assets10.lottiefiles.com/packages/lf20_ZUa1Q1.json",repeat: true),
                  Text("5",style: TextStyle(color: Colors.white60,fontSize: 65,fontWeight: FontWeight.w700,fontFamily: "Lato"),),
                ],
              ),
              Text("commutes left",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w700,fontFamily: "Lato"),),

              Padding(
                padding: EdgeInsets.only(left: 45, right: 45, top: 10,bottom: 0),
                child: Text("We search for the nearest police station, hospitals, gas stations, crowds and show you the best route possible. The enhancement of he route is color coded with green red and orange lines",style: TextStyle(color: Colors.white38, fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 12),),
              ),

              // Container(
              //   height: 230,
              //   width: MediaQuery.of(context).size.width,
              //   child: Swiper(
              //     itemBuilder: (BuildContext context, int index)
              //     {
              //       return Card(color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),elevation: 5,child: Center(child: Text(index.toString())),);
              //     },
              //     itemCount: 3,
              //     itemWidth: 300.0,
              //     itemHeight: 200,
              //     duration: 300,
              //     autoplay: false,
              //     layout: SwiperLayout.STACK,
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}

