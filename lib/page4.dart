import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
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
                "Find me a garage  ",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 30),
              child: Text(
                "We find the nearest garages that may help you. Just don't forget to contact them.",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
            ColorFiltered(
              child: Center(
                  child: Lottie.network(
                      "https://assets10.lottiefiles.com/packages/lf20_hgtip2wo.json")),
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcATop),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fix Now garage",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Use the button below to contact them.",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              Icons.call_outlined,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Call us",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                            ),
                          ),
                          TextButton.icon(
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Location",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.3,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Twoflex garage",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Use the button below to contact them.",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: "Lato",
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              Icons.call_outlined,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Call us",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                            ),
                          ),
                          TextButton.icon(
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Location",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                              overlayColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.3,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
