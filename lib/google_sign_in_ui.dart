import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:karten/locate_splash_screen.dart';
import 'package:karten/main.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin{


  getPermissions() async
  {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.sms.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
    }

    var status2 = await Permission.location.status;
    if (status2.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
    }

// You can can also directly ask the permission about its status.

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 35,right: 35,top: 40),
                child: Text("Getting started",style: TextStyle(color: Colors.grey[600],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 22),),
              ),
              Center(
                  child: Lottie.asset("assets/scrolldownAnimation.json")
              ),


              Padding(
                padding: EdgeInsets.only(left: 30,right: 30,top: 30),
                child: Text("Sign up",style: TextStyle(color: Colors.grey[600],fontFamily: "Lato",fontSize: 30,fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30,right: 30,bottom: 20),
                child: Text("For safety",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontSize: 40,fontWeight: FontWeight.w700),),
              ),


              //from views

              SignupButton(),

              Padding(
                padding: EdgeInsets.only(left: 35,right: 35,top: 0),
                child: Text("© KARTEN by dotdevelopingteam",style: TextStyle(color: Colors.grey[700],fontFamily: "Lato",fontWeight: FontWeight.w700,fontSize: 15),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class SignupButton extends StatelessWidget {

  String? name;
  String? email;
  String? imageUrl;

  User? user;


  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


//this key is for Scaffold snackbar display
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  Future<User?> _signIn() async
  {
    print("ghghghghggggggggggggggggggggggggggg############################");
    //these lines are used to sign in the user with Google Auth
    await Firebase.initializeApp();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    // final AuthResult authResult = await auth.signInWithCredential(credential);
    // final User user = authResult.user;

    user = (await auth.signInWithCredential(credential)).user;
    if (user != null) {
      name = user!.displayName;
      email = user!.email;
      imageUrl = user!.photoURL;
    }
    print("ghghghghggggggggggggggggggggggggggg############################");
    print(user);
    return user;
  }

  void showToast(BuildContext context,String value) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1),
          content: Row(
            children: [
              Icon(Icons.error_outline,color: Colors.white,),
              Text(value,style: TextStyle(color: Colors.white,fontFamily: "Lato"),)
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 35,right: 35,top: 20,bottom: 30),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width-70,
        child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
          ),
          icon: Image.asset("assets/google.png",height:27,color: Colors.white,),
          label: Text("Sign up now",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontWeight: FontWeight.w600,fontSize: 16),),
          onPressed: () {
            _signIn().whenComplete(() {
              print("you");
              print(user!.displayName);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LocateSplashScreen()), (Route<dynamic> route) => false);
            }).catchError((onError) {
              print(onError);
              showToast(context, "  An error occurred. Try again");
            });
          },
        ),
      ),
    );
  }
}

