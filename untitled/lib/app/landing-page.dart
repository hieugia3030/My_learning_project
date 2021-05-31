import 'package:flutter/material.dart';
import 'package:untitled/app/home_page.dart';
import 'package:untitled/app/sign_in/sign_in_page.dart';
import 'package:untitled/services/auth.dart';

// đây là 1 trang điều hướng
// nếu user đã đăng nhập thì đc navigate đến HomePage, còn ko thì ở lại đăng nhập tiếp ;)

class LandingPage extends StatefulWidget {
LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    widget.auth.onAuthStateChanged.listen((user){
      print('user: ${user?.uid}');
    });
  }
  // nếu đã dăng nhập rồi thì lần sau ko phải đăng nhập lại lần nữa
  Future<void> _checkCurrentUser() async {
    User user = await widget.auth.currentUser();
    _updateUser(user);
  }
  void _updateUser(User user){
    setState(() {
      _user = user; // nếu user đã đăng nhập thì rebuild widget và điều hướng sang HomePage
    });
  }
  @override
  Widget build(BuildContext context) {
    return (_user == null) ? SignInPage(onSignIn: _updateUser, auth: widget.auth,) : HomePage(onSignOut: () => _updateUser(null), auth: widget.auth,); // phần điều hướng
  }
}
