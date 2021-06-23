import 'dart:async';
import 'package:untitled/app/home/properties_of_jobs_page/job_form/jobs_form.dart';
import 'package:untitled/app/home/properties_of_jobs_page/list_item_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:untitled/app/home/job_entries/entry_list_item.dart';
import 'package:untitled/app/home/job_entries/entry_page.dart';
import 'package:untitled/app/home/models/entry.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  void _navigateToJobForm(BuildContext context, {Job job, Database database}) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => JobForm.create(context, job: job, database: database),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobID: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => EntryPage.show(
                      context: context, database: database, job: job),
                ),
                TextButton(
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () =>
                      _navigateToJobForm(context, job: job, database: database),
                ),
              ],
            ),
            body: _buildContent(context, job),

          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
