import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/Screans/Home_screan.dart';
import 'package:phoneauth_firebase/modiels/user_model.dart';
import 'package:phoneauth_firebase/utils/utils.dart';
import 'package:phoneauth_firebase/widgtes/custtom_button.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider
            .of<Authprovider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(child: isLoading == true ? const Center(
        child: CircularProgressIndicator(
          color: Colors.purple,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5.0),
        child: Center(
          child: Column(children: [
            InkWell(onTap:()=>selectImage(),
              child: image == null ? const CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 50,
                child: Icon(Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),

              )
                  : CircleAvatar(
                backgroundImage: FileImage(image!),
                radius: 50,

              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  textFeild(
                      hintText: "Samar Amir",
                      icon: Icons.account_circle,
                      inputType: TextInputType.name,
                      maxLines: 1,
                      controller: nameController

                  ),
                  textFeild(
                      hintText: "name@example.com",
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      maxLines: 1,
                      controller: emailController
                  ),
                  textFeild(
                      hintText: "Enter you ...",
                      icon: Icons.edit,
                      inputType: TextInputType.emailAddress,
                      maxLines: 2,
                      controller: emailController
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 90.0,
              child: CustomButton(
                text: "continue",
                onPressed: () => storeData(),
              ),
            )


          ],

          ),
        ),
      )

      ),
    );
  }

  Widget textFeild({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller
  })
  {
    return Padding(padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      cursorColor: Colors.purple,
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.purple,

          ),
          child: Icon(icon,size: 20,color: Colors.white,),

        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent)
        ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true


      ),

    ),
    );

  }
  void storeData()async {
   final ap=Provider.of<Authprovider>(context,listen: false);
   UserModel userModel = UserModel(
       name: nameController.text.trim(),
    email: emailController.text.trim(),
    bio: bioController.text.trim(),
    profilePic: "",
    createdAt: "",
    phoneNumber: "",
    uid: "",
   );
   if(image!=null){
     ap.saveUserDataToFirebase(context: context,
         userModel: userModel,
         profilePic: image!,
         onSuccess: (){
          ap.saveUserDataToSP().then(
              (value)=>ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                    context,
                        MaterialPageRoute(builder:(context) => const HomeScreen(),
                        ),
                              (route) => false),

              ),
          );

         }
     );
   }
   else{
      showScanBar(context, "please upload your profile");

   }


  }
}

