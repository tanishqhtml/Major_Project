import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:background_sms/background_sms.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

class AccidentDetectionOnPage extends StatefulWidget {
  List<double> gyroscopicAverageValues;
  AccidentDetectionOnPage({required this.gyroscopicAverageValues});

  @override
  State<AccidentDetectionOnPage> createState() => _AccidentDetectionOnPageState(gyroscopicAverageValues: gyroscopicAverageValues);
}

class _AccidentDetectionOnPageState extends State<AccidentDetectionOnPage> {

  List<double> gyroscopicAverageValues;
  _AccidentDetectionOnPageState({required this.gyroscopicAverageValues});

  late final streamForGyroscopeData;
  StreamSubscription? gyroscopeSubscription;
  StreamSubscription<LocationData>? locationSubscription;


  int thresholdForGyroscope = 10;
  double thresholdSpeed = 4.5;

  Location location = Location();


  List<double> speedList = [0];
  List<double> speedListForSOS = [0];

  bool isCriticalAnalyzing = false;
  bool isSOSinitiated = false;


  double criticalAverageSpeed = 0;
  double sosAverageSpeed = 0;

  String status = "You are safe";
  String statusAnimation = "assets/safe_tick_animation.json";

  final CountDownController controller = CountDownController();

  final assetsAudioPlayer = AssetsAudioPlayer();

  late LocationData accidentLocation;




  gyroscopicStreamFunction() async
  {
    //adding threshold to values
    startLocationStreamOnChanged();

    streamForGyroscopeData = await SensorManager().sensorUpdates(sensorId: Sensors.GYROSCOPE,interval: const Duration(milliseconds: 30));
    gyroscopeSubscription = streamForGyroscopeData.listen((sensorEvent) {
      //print(sensorEvent.data);
      checkForGyroscopicJerk(sensorEvent.data as List<double>);
    });
  }

  resumeDetectionActivity() async
  {
    status = "You are safe";
    statusAnimation = "assets/safe_tick_animation.json";
    
    setState(() {
      
    });
    
    print("ACTIVITY RESUMED");
    startLocationStreamOnChanged();
    gyroscopeSubscription = streamForGyroscopeData.listen((sensorEvent) {
      //print(sensorEvent.data);
      checkForGyroscopicJerk(sensorEvent.data as List<double>);
    });
  }

  startLocationStreamOnChanged() async
  {
    location.changeSettings(accuracy: LocationAccuracy.navigation);
    locationSubscription = location.onLocationChanged.listen((event) {
      print(event.latitude);
      if(isSOSinitiated)
      {
        speedListForSOS.add(event.speed!);
      }


      //complete critical analysis

      if(isCriticalAnalyzing)
        {
          if(speedList.length < 8)
          {
            speedList.add(event.speed!);
          }
          else if(speedList.length >= 8)
          {
            print("2555 VALUES REACHED");
            locationSubscription?.pause();
            checkForSOSWaitTime();
          }
        }
      print(speedList);
    });
  }

  checkForGyroscopicJerk(List<double> gyroscopicData) async
  {
    if(gyroscopicData[0].abs() >= gyroscopicAverageValues[0] || gyroscopicData[1].abs() >=  gyroscopicAverageValues[1] || gyroscopicData[2].abs() >=  gyroscopicAverageValues[2])
      {
        print("SHOCKKKKK");
        gyroscopeSubscription?.pause();

        status = "Suspicious";
        statusAnimation = "assets/suspisious_animation.json";
        
        setState(() {
          
        });

        isCriticalAnalyzing = true;
        speedList = [0];

      }
  }

  checkForSOSWaitTime() async
  {
    if(speedList.isNotEmpty)
      {
        for(int i = 0 ;i < speedList.length; i++)
          {
            criticalAverageSpeed += speedList[i];
          }
        print("CRITICAL AVG SPEED: " + (criticalAverageSpeed/8).toString());

        if(criticalAverageSpeed/8 >= 4.5)
          {
            // body is moving
            isCriticalAnalyzing = false;
            isSOSinitiated = false;
            speedList = [0];
            speedListForSOS = [0];

            locationSubscription?.cancel();
            gyroscopeSubscription?.cancel();
            resumeDetectionActivity();
          }
        else if(criticalAverageSpeed/8 < 4.5)
          {
            // SOS Timer algo
            status = "Worried about you";
            statusAnimation = "assets/danger_animation.json";
            
            setState(() {
              
            });

            isSOSinitiated = true;
            speedListForSOS = [0];
            await Future.delayed(Duration(seconds: 20)).whenComplete((){
              for(int i = 0; i< speedListForSOS.length;i++)
                {
                  sosAverageSpeed += speedListForSOS[i];
                }

              sosAverageSpeed += sosAverageSpeed/speedListForSOS.length;

              if(sosAverageSpeed >= 4.5)
                {
                  //No accident alert
                  // body is moving
                  isCriticalAnalyzing = false;
                  isSOSinitiated = false;

                  speedListForSOS = [0];
                  speedList = [0];
                  print("NOT AN ACCIDENT");
                  locationSubscription?.cancel();
                  gyroscopeSubscription?.cancel();
                  resumeDetectionActivity();
                }
              else if(sosAverageSpeed < 4.5)
                {
                  //Fire alert
                  showSOSAlertDialog(context);

                }
            });

          }
      }
  }

  showSOSAlertDialog(BuildContext context) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      title: const Text("Respond to the alert!",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700,color: Colors.black,fontSize: 24),),
      content: Container(
        height: 300,
        child: Column(
          children: [
            CircularCountDownTimer(
              duration: 30,
              controller: controller,
              width: 150,
              height: 150,
              ringColor: Colors.red.shade800,
              fillColor: Colors.black,
              backgroundColor: Colors.white,
              strokeWidth:8,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Lato"),
              textFormat: CountdownTextFormat.S,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () {
                debugPrint('Countdown Started');

                assetsAudioPlayer.open(Audio("assets/sos_alert_sound.mp3"),);
                assetsAudioPlayer.setLoopMode(LoopMode.playlist);
                assetsAudioPlayer.play();

              },
              onComplete: () async
              {
                debugPrint('Countdown Ended');
                await assetsAudioPlayer.dispose();
                
                sendSOSUrgently(["9082211871"]);

                status = "SOS sent";
                statusAnimation = "assets/safe_tick_animation.json";

                setState(() {

                });
                //sendSOSFunction
                Navigator.of(context).pop();
              },
            ),
            Text("\nRespond to the button asap! Otherwise we would send an SOS!", style: TextStyle(color: Colors.grey, fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 15),),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top:10),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[900]), elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: Text("Yes I am safe", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async
                  {


                    //No accident alert
                    // body is moving
                    isCriticalAnalyzing = false;
                    isSOSinitiated = false;



                    speedListForSOS = [0];
                    speedList = [0];
                    print("NOT AN ACCIDENT");

                    await assetsAudioPlayer.pause();
                    await assetsAudioPlayer.stop();
                    await assetsAudioPlayer.dispose();

                    locationSubscription?.cancel();
                    gyroscopeSubscription?.cancel();
                    resumeDetectionActivity();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  sendSOSUrgently(List<String> recipents) async
  {
    accidentLocation = await location.getLocation();
    String mapURLForLiveLocation = "https://www.google.com/maps/search/?api=1&query=${accidentLocation.latitude.toString()},${accidentLocation.longitude.toString()}";

    String message = "PAUL HAS MEET WITH AN ACCIDENT\nLIVE LOCATION: "+mapURLForLiveLocation;
    String message2 = "We have informed nearest police and hospital. They will reach soon.\n\nKarten by dotdevelopingteam.";


    SmsStatus result = await BackgroundSms.sendMessage(phoneNumber: "+918698882935", message: message).whenComplete(()async {
      SmsStatus result2 = await BackgroundSms.sendMessage(phoneNumber: "+918698882935", message: message2);
      if (result2 == SmsStatus.sent)
      {
        print(message2.length);
      }
      else
      {
        print("Failed");
      }
    });
    if (result == SmsStatus.sent)
    {
      print("Sent @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    }
    else
    {
      print("Failed");
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0;i<3;i++)
    {
      gyroscopicAverageValues[i] += thresholdForGyroscope;
    }
    gyroscopicStreamFunction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    gyroscopeSubscription?.cancel();
    locationSubscription?.cancel();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accident detection turned on",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700,color: Colors.white),),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),onTap: (){
          Navigator.of(context).pop();
        },),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
              child: Text("Accident detection is turned on. You can stop it anytime you wish. Please do not exit.", style: TextStyle(color: Colors.grey[500], fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 15),),),


            Stack(
              alignment: Alignment.center,
              children: [
                Lottie.network("https://assets3.lottiefiles.com/packages/lf20_mhraiglb.json"),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(statusAnimation,height: 50,repeat: false),
                      Text(status,style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700,color: Colors.white,fontSize: 24),),
                    ],
                  ),
                ),

              ],
            ),




            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("Keeping you safe",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("with urgent SOS triggers",style: TextStyle(color: Colors.grey[400],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("to police, hospitals, people",style: TextStyle(color: Colors.grey[700],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0,bottom: 20),
              child: Text("and your family.",style: TextStyle(color: Colors.red[400],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top:10),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[900]), elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: Text("Stop detection", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async {

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

