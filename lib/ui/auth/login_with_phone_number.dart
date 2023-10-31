import 'package:firebase_auth/firebase_auth.dart';
import 'package:firee/ui/auth/verify_code.dart';
import 'package:firee/utilies/utilites.dart';
import 'package:firee/widget/round_button.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();
  final _mykey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🚀',
              style: TextStyle(fontSize: 100.0),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Form(
              key: _mykey,
              child: TextFormField(
                //keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: '+923 4996 01525',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required😒..';
                  }
                  // Add additional validation logic for phone number format if needed
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RoundButton(
              loading: loading,
              title: 'Login',
              onTap: () {
                setState(() {
                  loading = true;
                });
                if (_mykey.currentState!.validate()) {}
                auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utiles().textMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCode(
                            verificationId: verificationId,
                          ),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utiles().textMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
// decoration: InputDecoration(
//                 hintText: '+923 34996 01525',
//               ),