
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/app/home/job_entries/format.dart';
import 'package:untitled/app/home/models/entry.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';

class EntryListItemModel {
  EntryListItemModel({@required this.entry,@required this.job, @required this.context});

  final Entry entry;
  final Job job;
  final BuildContext context;

  String get dayOfWeek => Format.dayOfWeek(entry.start);
  String get startDate => Format.date(entry.start);
  String get startTime => TimeOfDay.fromDateTime(entry.start).format(context);
  String get endTime => TimeOfDay.fromDateTime(entry.end).format(context);
  String get durationFormatted => Format.hours(entry.durationInHours);

  double get pay => job.ratePerHour * entry.durationInHours;
  String get payFormatted => Format.currency(pay);
}