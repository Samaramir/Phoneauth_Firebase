import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/Screans/user_information.dart';
import 'package:pinput/pinput.dart';
import 'package:firebaseproject/provider/auth_provider.dart';
import 'package:firebaseproject/screens/home_screen.dart';
import 'package:firebaseproject/screens/user_information.dart';
import 'package:firebaseproject/utils/utiles.dart';
import 'package:firebaseproject/widgets/custome_button.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgtes/custtom_button.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId ;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal:30 ,vertical:20 ),
      child: Column(
        children: [
          Align(
            alignment:Alignment.topLeft ,
            child: GestureDetector(
              onTap: ()=>Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back),
            ),
          ),
        Container(
        width: 200,
        height:200 ,
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,color: Colors.purple.shade50,
        ),

        child: Image.asset("assets/Signup.jpg"),


      ),
      const SizedBox(height: 20,),
      const Text("Verification",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
      const SizedBox(height: 10,),
      const Text("Enter the Opt your Phone Number",style: TextStyle(fontSize: 14,
        color:Colors.black38,
        fontWeight:FontWeight.bold,

      ),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: 20,),
          Pinput(
            length: 6,
            showCursor: true,
            defaultPinTheme: PinTheme(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple.shade200)
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )
            ),
            onCompleted: (value)
            {
              setState(() {
                otpCode = value;
              });
            },
          ),
          const SizedBox(height: 25,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: CustomButton(
                text: "Verify",
                onPressed: ()
                {
                  if(otpCode != null)
                  {
                    verifyOtp(context, otpCode!);

                  }else{
                    showSnackBar(context, "Enter 6-Digit code");
                  }
                }
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            "Didn't receive any code?",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38
            ),
          ),
          const SizedBox(height: 10,),
          const Text(
            "Resend New Code",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple
            ),
          )

        ],),),),),);
  }

  void verifyOtp(BuildContext context,String userOtp)
  {
    final ap = Provider.of<Authprovider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: ()
    {
      ap.checkExistingUser().then((value) async{
        if(value == true){
          ap.getDataFromFireStore().then(
                  (value) => ap.saveUserDataToSP().then(
                        (value) => ap.setSignIn().then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                                (route) => false),

                        ),

                  ),

          );


        }else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context)=> const UserInformationScreen()),
                  (route) => false
          );
        }




      }

      );
    }
    );
  }

}

