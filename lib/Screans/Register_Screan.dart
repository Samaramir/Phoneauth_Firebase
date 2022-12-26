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
          padding: EdgeInsets.symmetric(horizontal:25 ,vertical:35 ),
          child: Column(
            children: [],
          ),
        ),),
      ),
    );
  }
}
