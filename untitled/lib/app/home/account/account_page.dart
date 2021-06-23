import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/common_widgets/avatar.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';
import 'package:untitled/services/auth.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);
  
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Đăng xuất',
      content: 'Bạn có chắc không?',
      defaultActionText: 'OK',
      cancelText: 'Không',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản'),
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
        bottom: PreferredSize(
            child:  _buildUserInfo(user),
            preferredSize: Size.fromHeight(130.0),
        ),
      ),
      body: _buildContents(context),
    );

  }

  _buildContents(BuildContext context) {}

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
            photoUrl: user.photoUrl,
            radius: 50.0,
        ),
        SizedBox(height: 8.0,),
        if(user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        SizedBox(height: 8.0,),
      ],
    );
  }
}
