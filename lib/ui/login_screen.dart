import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/post/post_screen.dart';
import 'package:flutter_firebase/ui/forgot_password.dart';
import 'package:flutter_firebase/ui/login_with_phone.dart';
import 'package:flutter_firebase/ui/signup_screen.dart';
import 'package:flutter_firebase/utils/app_constants.dart';
import 'package:flutter_firebase/utils/utils_function.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loader = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loader = true;
    });
    if (_formKey.currentState!.validate() == true) {
      _auth
          .signInWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) {
        setState(() {
          loader = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
        debugPrint('User login: ${value.user!.email}');
        Utils().flutterToast('User login:${value.user!.email}');
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
        centerTitle: true,
        title: Text(AppConstants.login),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      prefixIcon: Icon(
                        Icons.lock,
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
            InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
                child: Text("Forgot Passowrd")),

            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: AppConstants.login,
              loader: loader,
              onTap: () {
                if (_formKey.currentState!.validate() == true) {
                  login();
                }
              },
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have any account? "),
                  Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWithPhone(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login with phone'),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
