import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:karten/accident_detection_on_page.dart';
import 'package:flutter_sensors/flutter_sensors.dart';



class AccidentDetectionCalibrationView extends StatefulWidget {
  const AccidentDetectionCalibrationView({Key? key}) : super(key: key);

  @override
  State<AccidentDetectionCalibrationView> createState() => _AccidentDetectionCalibrationViewState();
}

class _AccidentDetectionCalibrationViewState extends State<AccidentDetectionCalibrationView> {

  final CountDownController controller = CountDownController();
  bool isStarted = false;

  late final streamForGyroscopeData;
  StreamSubscription? gyroscopeSubscription;
  bool isGyroscopeAvailable = false;

  int calibrationDuration = 15;

  double gyroscopeXvaluesAverage = 0.0;
  double gyroscopeYvaluesAverage = 0.0;
  double gyroscopeZvaluesAverage = 0.0;

  int counterForGyroscopicIterations = 0;



  Future checkGyroscopeStatus() async {
    await SensorManager().isSensorAvailable(Sensors.GYROSCOPE).then((result) {
      isGyroscopeAvailable = result;
    });
  }

  streammm() async
  {
    await checkGyroscopeStatus();
    if(isGyroscopeAvailable)
      {
          streamForGyroscopeData = await SensorManager().sensorUpdates(sensorId: Sensors.GYROSCOPE,interval: const Duration(milliseconds: 30));
          gyroscopeSubscription = streamForGyroscopeData.listen((sensorEvent) {
            print(sensorEvent.data);
            calibratingDeviceWithAverage(sensorEvent.data as List<double>);
          });
      }
    else
    {
          print("No gyro");
    }


  }

  calibratingDeviceWithAverage(List<double> gyroscopicValues)
  {
    gyroscopeXvaluesAverage += gyroscopicValues[0].abs();
    gyroscopeYvaluesAverage += gyroscopicValues[1].abs();
    gyroscopeZvaluesAverage += gyroscopicValues[2].abs();
    counterForGyroscopicIterations++;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keep your device stationary",style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700,color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,),onTap: (){
          Navigator.of(context).pop();
        },),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
              child: Text("Place your device in vehicle while driving. Do not move the device. Tap when you have started driving.", style: TextStyle(color: Colors.grey[500], fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 15),),),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: CircularCountDownTimer(
                  duration: calibrationDuration,
                  controller: controller,
                  width: 150,
                  height: 150,
                  ringColor: Colors.black12,
                  fillColor: Colors.black,
                  backgroundColor: Colors.white,
                  strokeWidth:8,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold,fontFamily: "Lato"),
                  textFormat: CountdownTextFormat.S,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: false,
                  onStart: () {
                    debugPrint('Countdown Started');
                    streammm();

                  },
                  onComplete: () async{
                    debugPrint('Countdown Ended');
                    gyroscopeSubscription?.cancel();
                    print(counterForGyroscopicIterations);
                    gyroscopeXvaluesAverage /= counterForGyroscopicIterations;
                    gyroscopeYvaluesAverage /= counterForGyroscopicIterations;
                    gyroscopeZvaluesAverage /= counterForGyroscopicIterations;

                    print(gyroscopeXvaluesAverage);
                    print(gyroscopeYvaluesAverage);
                    print(gyroscopeZvaluesAverage);



                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccidentDetectionOnPage(gyroscopicAverageValues: [gyroscopeXvaluesAverage,gyroscopeYvaluesAverage,gyroscopeZvaluesAverage],)));
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top:70),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[900]), elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: Text(isStarted?"Calibrating...":"Tap to calibrate", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async {
                    isStarted?(){}:controller.start();
                    isStarted = true;
                    setState(() {

                    });
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

