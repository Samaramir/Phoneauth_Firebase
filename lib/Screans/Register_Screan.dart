import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../widgtes/custtom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController=TextEditingController();
  Country SelectedCountery =Country(
      phoneCode: "20",
      countryCode:"EG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name:"Egypt",
      example: "Egypt",
      displayName: "Egypt",
      displayNameNoCountryCode: "EG",
      e164Key: ""
  );
  @override
  Widget build(BuildContext context) {
    phoneController.selection=TextSelection.fromPosition(TextPosition(offset:phoneController.text.length,
    ),
    );
    return Scaffold(
      body: SafeArea(
        child: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:35 ,vertical:25 ),
          child: Column(
            children: [
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
              const Text("Register",style: TextStyle(fontSize: 22,fontWeight:FontWeight.bold),),
          const SizedBox(height: 10,),
          const Text("Add your phone number. We'll send you a verification code",style: TextStyle(fontSize: 14,
              color:Colors.black38,
              fontWeight:FontWeight.bold,

          ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20,),
              TextFormField(
                cursorColor: Colors.purple,
                controller: phoneController,
                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                onChanged: (value){
                  setState(() {
                    phoneController.text =value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  helperStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey.shade600,
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const BorderSide(color: Colors.black12),
                  ),
                   prefixIcon: Container(
                     padding: const EdgeInsets.all(8.0),
                     child: InkWell(
                       onTap: (){
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                              bottomSheetHeight: 500,
                            ),
                            onSelect: (value){
                              setState(() {
                                SelectedCountery=value;
                              });

                            });
                       },
                       child: Text("${SelectedCountery.flagEmoji} +${SelectedCountery.phoneCode}",
                         style: const TextStyle(
                         fontSize: 18,
                         color: Colors.black,
                         fontWeight: FontWeight.bold,
                       ),),
                     ),
                   ),
                  suffixIcon:phoneController.text.length > 9 ?Container(
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.done,color: Colors.white,size: 20,),
                  ):null
                ),

              ),
              const SizedBox(height: 20,),
              SizedBox(
                width:double.infinity ,
                height: 50,
                child: CustomButton(
                  text: "LOGIN",
                  onPressed: ()=>sendPhoneNumber(),
                ),
              )
            ],
          ),
        ),),
      ),
    );
  }
  void sendPhoneNumber(){
    final ap =Provider.of<Authprovider>(context ,listen: false);
    String PhoneNumber= phoneController.text.trim();
    ap .signInWithPhone(context, "+${SelectedCountery.phoneCode}$PhoneNumber");
  }
  void onTextChange(String txt) {
    phoneController.text=txt;
    phoneController.selection=TextSelection.fromPosition(TextPosition(offset: phoneController.text.length),);
    
  }
}
