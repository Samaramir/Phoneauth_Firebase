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
              Image.asset("assets/sign.png.jpg"),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
