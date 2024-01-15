import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'locate_splash_screen.dart';

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {

  bool styling = false;
  int time_val = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datacenter.isMinimalMap?styling=false:styling=true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 40),
              child: Text("Settings and info ",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 22),),
            ),

            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 7),
              child: Text("You can set up Karten your way. App designed by dotdevelopingteam for your safety.",style: TextStyle(color: Colors.grey[500],fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 15),),
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                Center(child: ColorFiltered(child: Lottie.network("https://assets8.lottiefiles.com/packages/lf20_jbmky2jv.json",height: 300),colorFilter: ColorFilter.mode(Colors.black,BlendMode.srcATop),)),
                Text("5",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontFamily: "Lato",fontSize: 29),textAlign: TextAlign.center,)
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("Oh no! you have only 5 safety",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("commutes left with you",style: TextStyle(color: Colors.grey[400],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0),
              child: Text("why don't you buy them for",style: TextStyle(color: Colors.grey[700],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 0,bottom: 20),
              child: Text("a cheap price.",style: TextStyle(color: Colors.red[400],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 00),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width-70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                  ),
                  child: Text("+ Buy 20 more",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "Lato",fontWeight: FontWeight.w600),),
                  onPressed: ()
                  {
                    setState(() {
                      styling = false;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 90,bottom: 0),
              child: Text("Set SOS time (minutes) ",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 5,bottom: 30),
              child: Text("Scroll left or right to set it.",style: TextStyle(color: Colors.grey[500],fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 15),),
            ),

            Center(
              child: NumberPicker(
                minValue: 1,
                maxValue: 7,
                selectedTextStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontFamily: "Lato",fontSize: 26),
                textStyle: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontFamily: "Lato",fontSize: 18),
                value: time_val,
                step: 1,
                itemCount: 3,
                haptics: true,
                axis: Axis.horizontal,
                onChanged: (int val){
                  setState(() {
                    time_val = val;
                  });
                },
              ),
            ),



            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 70,bottom: 20),
              child: Text("Choose map style ",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),

            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 20),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width-70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: styling?MaterialStateProperty.all(Colors.grey[500]):MaterialStateProperty.all(Colors.green[700]),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                  ),
                  child: Text("Minimal (Black & white)",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "Lato",fontWeight: FontWeight.w600),),
                  onPressed: ()
                  {
                    setState(() {
                      styling = false;
                      datacenter.isMinimalMap = true;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 10),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width-70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: styling?MaterialStateProperty.all(Colors.green[700]):MaterialStateProperty.all(Colors.grey[500]),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
                  ),
                  child: Text("Default (Google maps)",style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "Lato",fontWeight: FontWeight.w600),),
                  onPressed: ()
                  {
                    setState(() {
                      styling = true;
                      datacenter.isMinimalMap = false;
                    });
                  },
                ),
              ),
            ),




            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 60,bottom: 0),
              child: Text("Karten by dotdevelopingteam ",style: TextStyle(color: Colors.grey[800],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 20),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,right: 35,top: 5,bottom: 20),
              child: Text("coded by nerd and mindco.",style: TextStyle(color: Colors.grey[500],fontFamily: "Lato",fontWeight: FontWeight.w500,fontSize: 15),),
            ),

            Padding(padding: const EdgeInsets.only(left: 35,right: 35), child: ContactButtonSelectionWidget(),
            ),


          ],
        ),
      ),
    );
  }
}

class ContactButtonSelectionWidget extends StatefulWidget {
  const ContactButtonSelectionWidget({Key? key}) : super(key: key);

  @override
  State<ContactButtonSelectionWidget> createState() => _ContactButtonSelectionWidgetState();
}

class _ContactButtonSelectionWidgetState extends State<ContactButtonSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    List<CardItem> items = [
      IconTitleCardItem(
        text: "E-mail",
        iconData: Icons.mail_outline_rounded,
        selectedBgColor: Colors.black
      ),
      IconTitleCardItem(
          text: "Web",
          iconData: Icons.public,
          selectedBgColor: Colors.black
      ),
      IconTitleCardItem(
          text: "Info",
          iconData: Icons.info_outline_rounded,
          selectedBgColor: Colors.black
      ),
      IconTitleCardItem(
        text: "Report",
        iconData: Icons.bug_report_outlined,
        selectedBgColor: Colors.black
      ),
      IconTitleCardItem(
        text: "Rate",
        iconData: Icons.star_border_purple500_rounded,
        selectedBgColor: Colors.black
      )
    ];
    return Container(
      height: 100,
      child: HorizontalCardPager(
        onPageChanged: (page) {

        },
        onSelectedItem: (page){
          print(page);
        },
        items: items,
      ),
    );
  }
}

