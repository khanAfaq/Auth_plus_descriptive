import 'package:firebase_auth/firebase_auth.dart';
import 'package:firee/posts/post_screen.dart';
import 'package:firee/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const PostPage()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
