import 'package:flutter/material.dart';
import 'package:untitled/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.onSignOut, @required this.auth});

  final VoidCallback onSignOut;
  final AuthBase auth;

  Future<void> _signOut() async{
    try {
      await auth.signOut();
       onSignOut();
    } catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            child: Text(
                'Sign out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
