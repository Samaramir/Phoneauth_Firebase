import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/Screans/otp_screen.dart';
import 'package:phoneauth_firebase/modiels/user_model.dart';
import 'package:phoneauth_firebase/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authprovider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _uid;
  String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;


  Authprovider()
  {
    checkSigned();
  }

  void checkSigned() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_Signedin") ?? false;
    notifyListeners();
  }
  Future setSignIn() async {
    final SharedPreferences s=await SharedPreferences.getInstance();
    s.setBool("is_singedin",true);
    _isSignedIn=true;
    notifyListeners();

  }

  void signInWithPhone(BuildContext context, String PhoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: PhoneNumber,
          verificationCompleted: (
              PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  OtpScreen(
                    verificationId: verificationId
                  ))
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    }
    on FirebaseAuthException catch (e) {
      showScanBar(context, e.message.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,

  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userOtp
      );
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    }
    on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseStore
        .collection("users")
        .doc(_uid).get();
    if (snapshot.exists) {
      print("User Exist");
      return true;
    } else {
      print("New User");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  })async{
    _isLoading=true;
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
    on FirebaseAuthException catch (e)
    {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
  }
}

Future<String> storeFileToStorage(String ref, File file) async {
  UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}
Future getDataFromFireStore() async {
  await _firebaseStore
      .collection("users")
      .doc(_firebaseAuth.currentUser!.uid)
      .get()
      .then((DocumentSnapshot snapshot) {
    _userModel = UserModel(
      name: snapshot['name'],
      email: snapshot['email'],
      createdAt: snapshot['createdAt'],
      bio: snapshot['bio'],
      uid: snapshot['uid'],
      profilePic: snapshot['profilePic'],
      phoneNumber: snapshot['phoneNumber'],
    );
    _uid = userModel.uid;
  });
}
Future saveUserDataToSP() async {
  SharedPreferences s = await SharedPreferences.getInstance();
  await s.setString("user_model", jsonEncode(userModel.toMap()));
}
Future getDataFromSP() async {
  SharedPreferences s = await SharedPreferences.getInstance();
  String data = s.getString("user_model") ?? '';
  _userModel = UserModel.fromMap(jsonDecode(data));
  _uid = _userModel!.uid;
  notifyListeners();
}
Future userSignOut() async {
  SharedPreferences s = await SharedPreferences.getInstance();
  await _firebaseAuth.signOut();
  _isSignedIn = false;
  notifyListeners();
  s.clear();
}

}