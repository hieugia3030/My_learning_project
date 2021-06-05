import 'package:flutter/material.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';
import 'package:untitled/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({ @required this.auth});

  final AuthBase auth;

  Future<void> _signOut() async{
    try {
      await auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async{
    final didRequestSignOut = await PlatformAlertDialog(
        title: 'Đăng xuất',
        content: 'Bạn có chắc không ?',
        defaultActionText: 'Có',
      cancelText: 'Không',
    ).show(context);
    if (didRequestSignOut == true){
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            child: Text(
                'Đăng xuất',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
