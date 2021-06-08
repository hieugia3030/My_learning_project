import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/email_sign_in_page.dart';
import 'package:untitled/app/sign_in/sign_in_manager.dart';
import 'package:untitled/app/sign_in/sign_in_button.dart';
import 'package:untitled/app/sign_in/social_sign_in_button.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      exception: exception,
      title: 'Sign In Failed',
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    // TODO: Show email sign in page

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(isLoading),
              SizedBox(height: 48.0),
              SocialSignInButton(
                text: 'Đăng nhập bằng Google',
                color: Colors.white60,
                textColor: Colors.black87,
                assetName: 'google-logo',
                onPressed: () => !isLoading ? _signInWithGoogle(context) : null,
              ),
              SizedBox(height: 8.0),
              SocialSignInButton(
                text: 'Đăng nhập bằng Facebook',
                color: Color(0xFF334D92),
                textColor: Colors.white,
                assetName: 'facebook-logo',
                onPressed: () =>
                    !isLoading ? _signInWithFacebook(context) : null,
              ),
              SizedBox(height: 8.0),
              SocialSignInButton(
                assetName: 'email-logo',
                text: 'Đăng nhập bằng Email',
                textColor: Colors.white,
                color: Colors.blue[600],
                onPressed: () => !isLoading ? _signInWithEmail(context) : null,
              ),
              SizedBox(height: 8.0),
              Text(
                'hoặc',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.0),
              SignInButton(
                text: 'Đăng nhập ẩn danh',
                textColor: Colors.black,
                color: Colors.lime[700],
                onPressed: () =>
                    !isLoading ? _signInAnonymously(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Đăng nhập',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
