import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore/add_firestore_data.dart';
import 'package:flutter_firebase/firestore/firestore_list_screen.dart';
import 'package:flutter_firebase/post/post_screen.dart';
import 'package:flutter_firebase/ui/login_screen.dart';
import 'package:flutter_firebase/ui/upload_image.dart';

class SplashServices{
  final _auth = FirebaseAuth.instance;

  isLogin(BuildContext context){
    if(_auth.currentUser?.email !=null){
      Future.delayed(const Duration(seconds: 3), () {
        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UploadImage()),
        );
      });
    }else{
      Future.delayed(const Duration(seconds: 3), () {
        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }

  }
}