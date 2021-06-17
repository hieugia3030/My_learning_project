import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home/job_entries/job_entries_page.dart';
import 'package:untitled/app/home/properties_of_jobs_page/job_form/jobs_form.dart';
import 'package:untitled/app/home/properties_of_jobs_page/jobs_list_tile.dart';
import 'package:untitled/app/home/properties_of_jobs_page/list_item_builder.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';
import 'package:untitled/services/database.dart';

class EditJobPage extends StatelessWidget {
  const EditJobPage({Key key, this.job}) : super(key: key);

  final Job job; // để có thể thêm các job mới, bằng cách truyền vào thằng này 1 Job() có giá trị là null rồi chỉnh sửa sau ;)

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

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

  void _navigateToJobForm(BuildContext context, {Job job}) {
    if (job == null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => JobForm.create(context),
        ),
      );
    } else {
      Navigator.of(context).push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => JobForm.create(context, job: job),
          ),
      );
    }
  }

  Future<void> _delete(BuildContext context, Job job) async{
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on PlatformException catch (e){
      PlatformExceptionAlertDialog(
        title: 'LỖI',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom : 36.0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _navigateToJobForm(context),
        ),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Job> (
            snapshot: snapshot,
            itemBuilder: (context, job) =>  Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, job),
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            ));
        });
  }

}
