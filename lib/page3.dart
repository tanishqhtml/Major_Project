import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 35, right: 35, top: 40),
              child: Text(
                "Snap the accident!  ",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 40),
              child: Text(
                "You are a saviour if to click a photo of the accident and report it as soon as possible.\n\nThe app will send data to the nearest concerned authority.",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            Center(child:Lottie.network("https://assets3.lottiefiles.com/private_files/lf30_izjlsxva.json")),

            Padding(
              padding: EdgeInsets.only(left: 35, right: 35, top: 60),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[900]),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),
                  child: Text("Tap to report", style: TextStyle(color: Colors.white,fontSize: 16, fontFamily: "Lato", fontWeight: FontWeight.w600),),
                  onPressed: () async {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35, right: 35, top: 20),
              child: GestureDetector(
                onTap: (){print("hello");},
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 70,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          " Previous report",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


