import 'package:flutter/material.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Padding(
          padding: EdgeInsets.symmetric(horizontal:35 ,vertical:25 ),
          child: Column(
            children: [
              Container(width: 200,
                height:200 ,
                child: Image.asset(name),

              )
            ],
          ),
        ),),
      ),
    );
  }
}
