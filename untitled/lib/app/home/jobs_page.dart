import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home/models/job.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';

class JobsPage extends StatelessWidget {


  Future<void> _signOut(BuildContext context) async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false) ;
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
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async{
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(
        name: 'Blogging',
        ratePerHour: 10,
      ));
    } on PlatformException catch(e){
      print(e);
      PlatformExceptionAlertDialog(
          title: 'Lỗi dữ liệu',
          exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Công việc'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
      body:  _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
        builder: (context, snapshot) {
        if(snapshot.hasData){
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(
            children: children,
          );
        }
        if(snapshot.hasError){
          return Center(child: Text('Some error occurred'));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
        }
    );
  }
}
