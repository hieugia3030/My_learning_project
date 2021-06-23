import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/app/home/models/entry.dart';

void main(){
  group('durationInHors', (){
    test('int', (){
      final entry = Entry(
        id: 'abc',
        jobId: 'abc',
        start: DateTime(2021, 06, 21, 8, 26),
        end: DateTime(2021, 06, 21, 9, 26),
      );
      expect(entry.durationInHours, 1);
    });

    test('negative', (){
      final entry = Entry(
        id: 'abc',
        jobId: 'abc',
        start: DateTime(2021, 06, 21, 8, 26),
        end: DateTime(2021, 06, 21, 7, 26),
      );
      expect(entry.durationInHours, 0);
    });

    test('decimal', (){
      final entry = Entry(
        id: 'abc',
        jobId: 'abc',
        start: DateTime(2021, 06, 21, 8, 26),
        end: DateTime(2021, 06, 21, 9),
      );
      expect(entry.durationInHours, 0.6);
    });
  });

  group('fromMap', (){

    test('null value', (){
      expect(Entry.fromMap(null, 'abc'), null);
    });

    test('null id', (){
      Map <dynamic, dynamic> map = {
        'start': 1000,
        'end': 2000,
        'jobId': 'abc',
        'comment': 'dark',
      };
      expect(Entry.fromMap(map, ''), null);
    });

    test('true id, value', (){
      Map <dynamic, dynamic> map = {
        'start': 35500,
        'end': 50000,
        'jobId': 'abc',
        'comment': 'dark',
      };
      expect(Entry.fromMap(map, 'abc'), Entry(id: 'abc', jobId: 'abc', start: DateTime.fromMillisecondsSinceEpoch(35500), end: DateTime.fromMillisecondsSinceEpoch(50000), comment: 'dark'));
    });

    test('null comment', (){
      Map <dynamic, dynamic> map = {
        'start': 35500,
        'end': 50000,
        'jobId': 'abc',
      };
      expect(Entry.fromMap(map, 'abc'), Entry(id: 'abc', jobId: 'abc', start: DateTime.fromMillisecondsSinceEpoch(35500), end: DateTime.fromMillisecondsSinceEpoch(50000), comment: ''));
    });

    test('negative start', (){
      Map <dynamic, dynamic> map = {
        'start': -35500,
        'end': 50000,
        'jobId': 'abc',
        'comment': 'dark',
      };
      expect(Entry.fromMap(map, 'abc'), Entry(id: 'abc', jobId: 'abc', start: DateTime.fromMillisecondsSinceEpoch(0), end: DateTime.fromMillisecondsSinceEpoch(50000), comment: 'dark'));
    });

    test('negative end', (){
      Map <dynamic, dynamic> map = {
        'start': 35500,
        'end': -50000,
        'jobId': 'abc',
        'comment': 'dark',
      };
      expect(Entry.fromMap(map, 'abc'), Entry(id: 'abc', jobId: 'abc', start: DateTime.fromMillisecondsSinceEpoch(35500), end: DateTime.fromMillisecondsSinceEpoch(0), comment: 'dark'));
    });
  });

  group('toMap', (){
    test('negative end', (){
      final entry = Entry(id: 'abc', jobId: 'abc', start: DateTime(35500), end: DateTime(-50000), comment: 'hehe');
      final Map<String, dynamic> wantedResult = {
        'jobId': 'abc',
        'start': DateTime(35500).millisecondsSinceEpoch,
        'end':  0,
        'comment': 'hehe',
      };
      expect(entry.toMap(), wantedResult);
    });
  });
}