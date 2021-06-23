import 'package:flutter/cupertino.dart';
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
    if(name == null){
      return null;
    }
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

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    if(runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id && name == otherJob.name && ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}