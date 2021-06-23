import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home/edit_job_page.dart';
import 'package:untitled/app/home/properties_of_jobs_page/models/job.dart';
import 'package:untitled/services/database.dart';
import 'mock.dart';

void main() {
  MockDatabase mockDatabase;
  StreamController<List<Job>> jobsStreamController;
  setUp(() {
    mockDatabase = MockDatabase();
    jobsStreamController = StreamController<List<Job>>();
  });
  tearDown(() {
    jobsStreamController.close();
  });

  Future<void> pumpEditJobPage(WidgetTester tester,
      {VoidCallback onSignedIn, VoidCallback onRegistered}) async {
    await tester.pumpWidget(Provider<Database>(
      create: (_) => mockDatabase,
      child: MaterialApp(
        home: Scaffold(
          body: EditJobPage(),
        ),
      ),
    ));
    await tester.pump();
  }

  void stubJobsStream(Iterable<List<Job>> jobsStream) {
    jobsStreamController.addStream(Stream<List<Job>>.fromIterable(jobsStream));
    when(mockDatabase.jobsStream())
        .thenAnswer((_) => jobsStreamController.stream);
  }
  void stubJobsStreamFailed() {
    Error error = Error();
    jobsStreamController.addError(error);
    jobsStreamController.addError(error);
    jobsStreamController.addError(error);
    when(mockDatabase.jobsStream())
        .thenAnswer((_) => jobsStreamController.stream);  }

  group('test Edit Job Page', () {
    testWidgets('Stream is now empty', (WidgetTester tester) async {
      stubJobsStream([
        [],
      ]);
      await pumpEditJobPage(tester);

      expect(find.text(' 😞 Không có gì ở đây cả 😞'), findsOneWidget);
    });
    testWidgets('Stream with REAL value', (WidgetTester tester) async {
      stubJobsStream([
        [
          Job(
            ratePerHour: 20,
            name: 'abc',
            id: 'abc',
          ),
        ],
      ]);
      await pumpEditJobPage(tester);

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('Stream with an empty list', (WidgetTester tester) async {
      stubJobsStream([]);
      await pumpEditJobPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Stream with an list of NULL value', (WidgetTester tester) async {
      stubJobsStreamFailed();
      await pumpEditJobPage(tester);

      expect(find.text('Xin hãy thử lại sau !!!'), findsOneWidget);
    });
  });
}
