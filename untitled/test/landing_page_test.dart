import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/home/home_page.dart';
import 'package:untitled/app/landing-page.dart';
import 'package:untitled/app/sign_in/sign_in_page.dart';
import 'package:untitled/services/auth.dart';
import 'mock.dart';

void main() {
  MockAuth mockAuth;
  StreamController<User> onAuthStateChangedController;
  setUp(() {
    mockAuth = MockAuth();
    onAuthStateChangedController = StreamController<User>();
  });
  tearDown((){
  onAuthStateChangedController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester,
      {VoidCallback onSignedIn, VoidCallback onRegistered}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: LandingPage(),
        ),
      ),

    ));
    await tester.pump();
  }

  void stubOnAuthStateChanged(Iterable<User> onAuthStateChanged) {
    onAuthStateChangedController.addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.onAuthStateChanged)
        .thenAnswer((_) => onAuthStateChangedController.stream);
  }

  group('All form of Stream', () {
    testWidgets('Stream waiting', (WidgetTester tester) async {
      stubOnAuthStateChanged([]);
      await pumpLandingPage(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Stream had a NULL value', (WidgetTester tester) async {
      stubOnAuthStateChanged([null]);
      await pumpLandingPage(tester);
      expect(find.byType(SignInPage), findsOneWidget);
    });

    testWidgets('Stream had a REAL  value', (WidgetTester tester) async {
      stubOnAuthStateChanged([User(uid: 'abc')]);
      await pumpLandingPage(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
