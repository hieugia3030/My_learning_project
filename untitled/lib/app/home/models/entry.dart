import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.jobId,
    @required this.start,
    @required this.end,
    this.comment='',
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours {
    double result = end.difference(start).inMinutes.toDouble() / 60.0;
    if(result <= 0){
      return 0;
    }
    if(result is int){
      return result;
    }
    return double.parse(result.toStringAsFixed(1));
  }

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    if(value == null || id == null || id == '' ){
      print('ERROR: Entry.fromMap, id or value is null !!!!!!!!');
      return null;
    }
      final int startMilliseconds = value['start'] < 0 ? 0 : value['start'];
      final int endMilliseconds = value['end'] < 0 ? 0 : value['end'];
      return Entry(
        id: id,
        jobId: value['jobId'],
        start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
        end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
        comment: value['comment'] ?? '',
      );

  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch < 0 ? 0 : start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch < 0 ? 0 : end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  @override
  String toString() {
    return "'id: $id, jobId: $jobId, start: $start, end: $end, comment: $comment'";
  }

  @override
  bool operator ==(Object other) {
    if(identical(this, other)){
      return true;
    }
    if(runtimeType != other.runtimeType) return false;
    final Entry otherEntry = other;
    return id == otherEntry.id && start == otherEntry.start && end == otherEntry.end && comment == otherEntry?.comment ?? null;
  }

  @override
  int get hashCode {
    return hashValues(id, jobId, start, end, comment);
  }
}
