import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home_page.dart';
import 'package:untitled/app/sign_in/sign_in_page.dart';
import 'package:untitled/services/auth.dart';


// đây là 1 trang điều hướng
// nếu user đã đăng nhập thì đc navigate đến HomePage, còn ko thì ở lại đăng nhập tiếp ;)

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false) ;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
        builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          User user = snapshot.data;
        if(user ==  null){
          return SignInPage.create(context);
        }
         return HomePage();
        }
        else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        }
    );
  }
}
