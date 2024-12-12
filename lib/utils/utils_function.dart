import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Utils{
 void flutterToast(String title){
   Fluttertoast.showToast(
       msg: title,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0
   );
 }
}