import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

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
                onChanged: (value){
                  setState(() {
                    phoneController.text =value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter phone number",
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.done,color: Colors.white,size: 20,),
                  ):null
                ),

              )
            ],
          ),
        ),),
      ),
    );
  }
}
