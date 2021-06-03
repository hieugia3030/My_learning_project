import 'package:flutter/material.dart';
import 'package:untitled/app/sign_in/email_sign_in_form.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // giúp cho màn hình ko bị overflow khi hiện bàn phím lên
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
            child: EmailSignInForm(
              auth: auth,
            ),
        ),
      ),
    );
  }
}
