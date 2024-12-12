import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/verify_code.dart';
import 'package:flutter_firebase/utils/app_constants.dart';
import 'package:flutter_firebase/utils/utils_function.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {

  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loader = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with phone'),
        centerTitle: true,
      ),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Form(
               key: _formKey,
               child: Column(
               children: [
                 TextFormField(
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return "Phone cannot be empty";
                     }

                   },
                   controller: phoneController,
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                       hintText: 'Enter Phone'
                   ),
                 ),
               ],
             ),),
             SizedBox(height: 30,),
             RoundButton(
               title: AppConstants.loginWithPhone,
               loader: loader,
               onTap: () {
                 if (_formKey.currentState!.validate() == true) {
                   setState(() {
                     loader = true;
                   });
                   _auth.verifyPhoneNumber(
                     phoneNumber: '+92${phoneController.text}',
                       verificationCompleted: (value){
                         setState(() {
                           loader = false;
                         });
                       },
                       verificationFailed: (e){
                         setState(() {
                           loader = false;
                         });
                         Utils().flutterToast(e.toString());

                       },
                       codeSent: (String verificationId, int? code){
                         setState(() {
                           loader = false;
                         });
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCode(verificationId: verificationId,)));

                       },
                       codeAutoRetrievalTimeout: (e){
                         setState(() {
                           loader = false;
                         });
                         Utils().flutterToast(e.toString());
                       },
                   );
                 }
               },
             ),
           ],
         ),
       ),
    );
  }
}
