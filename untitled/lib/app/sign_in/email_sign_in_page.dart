import 'package:flutter/material.dart';
import 'package:untitled/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // giúp cho màn hình ko bị overflow khi hiện bàn phím lên
      appBar: AppBar(
        title: Text('Đăng nhập bằng Email'),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
