import 'dart:async';
import 'package:meta/meta.dart';
import 'package:untitled/app/home/models/job.dart';
import 'package:untitled/services/api_path.dart';
import 'package:untitled/services/firestore_services.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

final _service = FirestoreServices.instance;

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  Future<void> createJob(Job job) async => await _service.setData(
    path: APIPath.job(uid, 'job_abc'),
    data: job.toMap(),
  );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data) => Job.fromMap(data),
  );


}
