import 'package:flutter/material.dart';
import 'package:karten/accident_detection_info_page.dart';
import 'package:lottie/lottie.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 40),
              child: Text(
                "Accident detection  ",
                style: TextStyle(color: Colors.grey[800], fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 10),
              child: Text(
                "Be safe. Turn on the mode to inform your contacts and send SOS if any mishap happens.\n\nNearest police stations and hospitals are informed automatically.",
                style: TextStyle(color: Colors.grey[500], fontFamily: "Lato", fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
            Lottie.asset("assets/accident_detection_animation.json", repeat: true),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 0),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[900]), elevation: MaterialStateProperty.all(0), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  child: const Text("Tap to activate", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccidentDetectionInfoPage()));
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
