import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/app_constants.dart';
import 'package:flutter_firebase/utils/utils_function.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loader = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }


  void forgotPwd() {
    setState(() {
      loader = true;
    });
    if (_formKey.currentState!.validate() == true) {
      _auth
          .sendPasswordResetEmail(
        email: emailController.text.toString(),
      )
          .then((value) {
        setState(() {
          loader = false;
        });
        Utils().flutterToast('We have sent an email link to:${emailController.text.toString()}');
      }).onError((error, stackTrace) {
        Utils().flutterToast(error.toString());
        debugPrint('Error occurred: $error');
        setState(() {
          loader = false;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null; // Input is valid
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: AppConstants.forgot,
              loader: loader,
              onTap: () {
                if (_formKey.currentState!.validate() == true) {
                  forgotPwd();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
