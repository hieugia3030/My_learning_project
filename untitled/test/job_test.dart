import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';

void main(){
  group('fromMap', (){
    test('null data', (){
      final job = Job.fromMap(null, 'abc');
      expect(job, null);
    });

    test('job with all properties', (){
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(job, Job(name: 'Blogging', ratePerHour: 10, id: 'abc'));
    });

    test('missing name', (){
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(job, null);
    });
  });

  group('toMap', (){
    test('valid name and ratePerHour', (){
      final Job job = Job(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}