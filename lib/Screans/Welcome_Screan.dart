import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/Screans/Home_screan.dart';
import 'package:phoneauth_firebase/Screans/Register_Screan.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../widgtes/custtom_button.dart';



class WelcomeScrean extends StatefulWidget {
  const WelcomeScrean({Key? key}) : super(key: key);

  @override
  State<WelcomeScrean> createState() => _WelcomeScreanState();
}

class _WelcomeScreanState extends State<WelcomeScrean> {


  @override
  Widget build(BuildContext context) {
    final ap=Provider.of<Authprovider>(context,listen: false);
    return Scaffold(
      body: SafeArea( child: Center(
        child: Padding(
            padding:const EdgeInsets.symmetric(vertical: 25,horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Image.asset(
              "assets/sign.jpg",
              height:300,
              ),
              const SizedBox(height: 22),
              const Text("Let's get started",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
              const SizedBox(height: 10,),
              const Text("Never a better time than now to start",style: TextStyle(fontSize: 14,
                  color:Colors.black38,
                  fontWeight:FontWeight.bold),),
              const SizedBox(height: 20,),
              //Custom_Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  onPressed:(){
                    ap.isSignedIn == true
                        ?Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen())):

                    Navigator.push(context,MaterialPageRoute(builder:(context)=>const RegisterScreen(),),
                    );
                  },
                  text: "Get Started",
                ),
              )
              
            ],
          ),
        ),
      ),
      ),
    );
  }
}
