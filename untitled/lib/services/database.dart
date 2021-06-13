import 'dart:async';
import 'package:meta/meta.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/services/api_path.dart';
import 'package:untitled/services/firestore_services.dart';

abstract class Database {
  Future<void> createAndEditJob(Job job);
  Stream<List<Job>> jobsStream();
}

final _service = FirestoreServices.instance;
String generateDocumentIDFromCurrentDateTime() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;


  Future<void> createAndEditJob(Job job) async => await _service.setData(
    path: APIPath.job(uid, job.id),
    data: job.toMap(),
  );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data, documentID) => Job.fromMap(data, documentID),
  );


}
