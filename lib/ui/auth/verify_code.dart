import 'package:firebase_auth/firebase_auth.dart';
import 'package:firee/posts/post_screen.dart';
import 'package:firee/utilies/utilites.dart';
//import 'package:firee/utilies/utilites.dart';
import 'package:firee/widget/round_button.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final verificationCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Verification'),
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
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: verificationCodeController,
                decoration: InputDecoration(
                  hintText: '6 digit code',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RoundButton(
              loading: loading,
              title: 'Verify',
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final crediental = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text.toString(),
                );
                try {
                  await auth.signInWithCredential(crediental);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostPage(),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utiles().textMessage(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
