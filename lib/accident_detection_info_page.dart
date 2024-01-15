import 'package:flutter/material.dart';
import 'package:karten/accident_detection_extended.dart';
import 'package:lottie/lottie.dart';

class AccidentDetectionInfoPage extends StatelessWidget {
  const AccidentDetectionInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keep in mind!",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700,color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,),onTap: (){
          Navigator.of(context).pop();
        },),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
              child: Text("Place your device in vehicle while before calibration. Do not move the device. Tap when you have started driving.", style: TextStyle(color: Colors.grey[500], fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 15),),),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Lottie.asset("assets/phone_animation.json"),
                Text("Place your phone down",style: TextStyle(color: Colors.black54,fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 60),
              child: Card(
                elevation: 0,
                color: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20,left: 35,right: 35),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RotatedBox(child: Icon(Icons.battery_charging_full_rounded,size: 30,color: Colors.black54,),quarterTurns: 1,),
                          Text("  High battery usage",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 14),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.signal_cellular_alt,size: 30,color: Colors.black54,),
                          Text("  Needs strong network",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 14),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Icon(Icons.share_location,size: 30,color: Colors.black54,),
                          Text("  Timely location access",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 14),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top:10),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[900]), elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: Text("Continue", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccidentDetectionCalibrationView()));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
