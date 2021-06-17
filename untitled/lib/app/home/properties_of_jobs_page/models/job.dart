import 'package:flutter/foundation.dart';

class Job{
  Job({@required this.id, @required this.name, @required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap( Map <String, dynamic> data,   String documentID){
    if (data == null){
      return null;
    }
    final name = data['name'];
    final ratePerHour = data['ratePerHour'];
    return Job(
      id: documentID,
      name:  name,
      ratePerHour: ratePerHour,
    );
  }

  Map <String,dynamic> toMap(){
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}