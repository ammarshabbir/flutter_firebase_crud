
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/post/post_screen.dart';
import 'package:flutter_firebase/utils/app_constants.dart';
import 'package:flutter_firebase/utils/utils_function.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loader = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    codeController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify code'),
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
                        return "code cannot be empty";
                      }else if(value.length<6){
                        return "code length cannot be empty";
                      }

                    },
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Enter Phone'
                    ),
                  ),
                ],
              ),),
            SizedBox(height: 30,),
            RoundButton(
              title: AppConstants.verifyCode,
              loader: loader,
              onTap: () async{
                if (_formKey.currentState!.validate() == true) {
                  setState(() {
                    loader = true;
                  });
                 final credental = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: codeController.text);
                 try{
                   await _auth.signInWithCredential(credental);
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));

                 }catch(e){
                   Utils().flutterToast(e.toString());
                 }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
