import 'package:flutter/material.dart';
import 'package:untitled/app/sign_in/sign_in_button.dart';
import 'package:untitled/app/sign_in/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Text(
              'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: 'Sign in with Google',
            color: Colors.white,
            textColor: Colors.black87,
            assetName: 'google-logo',
            onPressed: (){},
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            color: Color(0xFF334D92),
            textColor: Colors.white,
            assetName: 'facebook-logo',

            onPressed: (){},
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'email-logo',
            text: 'Sign In with email',
            textColor: Colors.white,
            color: Colors.blue[600],
            onPressed: (){},
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,

            color: Colors.lime[700],
            onPressed: (){},
          ),

        ],
      ),
    );
  }
}
