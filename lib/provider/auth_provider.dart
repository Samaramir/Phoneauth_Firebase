import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/Screans/otp_screen.dart';
import 'package:phoneauth_firebase/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authprovider extends ChangeNotifier{
  bool _isSignedIn =false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading =false;
  bool get isLoading => _isSignedIn;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;



  Authprovider(){
    checkSigned();

}
void checkSigned() async{
    final SharedPreferences s= await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_Signedin")?? false;
    notifyListeners();

}
void signInWithPhone(BuildContext context ,String PhoneNumber)async{
   try{
     await _firebaseAuth.verifyPhoneNumber(
         phoneNumber:PhoneNumber,
         verificationCompleted: (PhoneAuthCredential phoneAuthCredential)async{
           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
         },
         verificationFailed: (error){
           throw Exception(error.message);
         },
         codeSent: (verificationId ,forceResendingToken){
         Navigator.push(context,
           MaterialPageRoute(builder: (context)=>OtpScreen(
             verificationId: verificationId,
           ),
           ),
         );
         },
         codeAutoRetrievalTimeout: (verificationId){});
   }
   on FirebaseAuthException catch(e){
     showScanBar(context,e.message.toString());
   }
}
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,

  })async{
    _isLoading=true;
    notifyListeners();
     try{
       PhoneAuthCredential creds = PhoneAuthProvider.credential(
       verificationId: verificationId,
        smsCode: userOtp
       );
       User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
       if(user != null)
       {
         _uid = user.uid;
         onSuccess();
       }
       _isLoading = false;
       notifyListeners();

}
     on FirebaseAuthException catch(e)
     {
       showSnackBar(context, e.message.toString());
       _isLoading = false;
       notifyListeners();
     }
}
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseStore
        .collection("users")
        .doc(_uid).get();
    if(snapshot.exists)
    {
      print("User Exist");
      return true;
    }else{
      print("New User");
      return false;
    }
  }
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  })
  _isLoading = true;
  notifyListeners();
  try{

  await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
  userModel.profilePic = value;
  userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
  userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
  userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
  });
  _userModel = userModel;
  await _firebaseStore
      .collection("users")
      .doc(_uid)
      .set(userModel.toMap())
      .then((value) {
  onSuccess();
  _isLoading = false;
  notifyListeners();
  });
  }


}