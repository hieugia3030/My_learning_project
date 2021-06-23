import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/sign_in_page.dart';
import 'package:untitled/services/auth.dart';

import 'mock.dart';

void main() {
  MockAuth mockAuth;
  MockNavigatorObservers mockNavigatorObservers;
  setUp(() {
    mockAuth = MockAuth();
    mockNavigatorObservers = MockNavigatorObservers();
  });
  Future<void> pumpSignInPage(WidgetTester tester,
      {VoidCallback onSignedIn, VoidCallback onRegistered}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) => SignInPage.create(context)),
        ),
        navigatorObservers: [mockNavigatorObservers],
      ),
    ));
    verify(mockNavigatorObservers.didPush(any, any)).called(1);
  }
  
  testWidgets('email and password navigation', (WidgetTester tester) async {
      final emailAndPasswordButton = find.text('Đăng nhập bằng Email');
      await pumpSignInPage(tester);
      expect(emailAndPasswordButton, findsOneWidget);

      await tester.tap(emailAndPasswordButton);
      await tester.pumpAndSettle();

      verify(mockNavigatorObservers.didPush(any, any)).called(1);
  });
}
