import 'package:flutter/material.dart';
import 'package:untitled/app/home/job_entries/entry_list_item_model.dart';
import 'package:untitled/app/home/models/entry.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.job,
    @required this.onTap,
  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final model = EntryListItemModel(entry: entry, job: job, context: context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(model.dayOfWeek,
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(model.startDate, style: TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              model.payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('${model.startTime} - ${model.endTime}',
              style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(model.durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment.isNotEmpty)
          Text(
            entry.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.job,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
