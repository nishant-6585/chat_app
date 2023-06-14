import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
            color: Theme
                .of(context)
                .primaryColor),
      )
          : SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Chat App",
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login now to see what they are talking!",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                ),
                kIsWeb
                    ? Image.asset("/login.png")
                    : Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      )),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                      if (kDebugMode) {
                        print(email);
                      }
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      )),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be at least 6 character";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                      if (kDebugMode) {
                        print(password);
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      child: const Text(
                        "Sign In",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Don't have an account?",
                  style:
                  const TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: " Register here",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, const RegisterPage());
                          }),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);

          // saving the values to shared preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserName(snapshot.docs[0]['fullName']);
          await HelperFunction.saveUserEmail(email);

          if (context.mounted) {
            nextScreenReplace(context, const HomePage());
          }
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
