import 'package:flutter/material.dart';



class WelcomeScrean extends StatefulWidget {
  const WelcomeScrean({Key? key}) : super(key: key);

  @override
  State<WelcomeScrean> createState() => _WelcomeScreanState();
}

class _WelcomeScreanState extends State<WelcomeScrean> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( child: Center(
        child: Padding(
            padding:const EdgeInsets.symmetric(vertical: 25,horizontal: 35),
          child: Column(
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
              const SizedBox(height: 20,)
              
            ],
          ),
        ),
      ),
      ),
    );
  }
}
