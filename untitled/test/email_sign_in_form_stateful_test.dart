import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:untitled/services/auth.dart';
import 'mock.dart';

void main() {
  MockAuth mockAuth;
  setUp(() {
    mockAuth = MockAuth();
  });
  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn, VoidCallback onRegistered}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(
            onSignedIn: onSignedIn ,
            onRegistered: onRegistered,
          ),
        ),
      ),
    ));
  }

  void stubSignInWithEmailAndPasswordSuccess() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(User(uid: '123')));
  }

  void stubSignInWithEmailAndPasswordFailed() {
    when(mockAuth.signInWithEmailAndPassword(any, any)).thenThrow(
        PlatformException(
            code: 'ERROR_WRONG_EMAIL_AND_PASSWORD',
            message: 'This is my kingdom come'));
  }

  group('sign in', () {
    testWidgets("email, password isn't entered", (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Đăng nhập');
      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        "email, password is now fucking entered,BUT right email and password",
        (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordSuccess();

      const email = 'email@gmail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Đăng nhập');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets(
        "email, password is now fucking entered,BUT this is not right email and password",
        (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordFailed();

      const email = 'email@gmail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Đăng nhập');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  void stubCreateUserWithEmailAndPasswordSucceed() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(User(uid: '123')));
  }

  void stubCreateUserWithEmailAndPasswordFailed() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(message: 'dark', code: 'ey'));
  }

  group('REGISTER', () {
    testWidgets("update UI when secondary button is tapped",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final secondaryButton = find.text('Chưa có tài khoản? Đăng kí');
      await tester.tap(secondaryButton);

      await tester.pump();

      final registerButton = find.text('Đăng kí');
      expect(registerButton, findsOneWidget);
    });

    testWidgets(
        "email, password is now fucking entered, check if the register UI work OKe AND the email, password is correct",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final secondaryButton = find.text('Chưa có tài khoản? Đăng kí');
      await tester.tap(secondaryButton);

      await tester.pump();

      const email = 'email@gmail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();
      stubCreateUserWithEmailAndPasswordSucceed();

      final registerButton = find.text('Đăng kí');
      await tester.tap(registerButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
    });

    testWidgets(
        "email, password is now fucking entered, check if the register UI work OKe AND the email, password is correct",
        (WidgetTester tester) async {
      bool registered = false;
      await pumpEmailSignInForm(tester, onRegistered: () => registered = true);

      final secondaryButton = find.text('Chưa có tài khoản? Đăng kí');
      await tester.tap(secondaryButton);

      await tester.pump();

      const email = 'email@gmail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();
      stubCreateUserWithEmailAndPasswordSucceed();

      final registerButton = find.text('Đăng kí');
      await tester.tap(registerButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
      expect(registered, true);
    });

    testWidgets(
        "email, password is now fucking entered, check if the register UI work OKe AND the email, password is NOT  correct",
        (WidgetTester tester) async {
      bool registered = false;
      await pumpEmailSignInForm(tester, onRegistered: () => registered = true);

      final secondaryButton = find.text('Chưa có tài khoản? Đăng kí');
      await tester.tap(secondaryButton);

      await tester.pump();

      const email = 'email@gmail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final registerButton = find.text('Đăng kí');
      await tester.tap(registerButton);

      stubCreateUserWithEmailAndPasswordFailed();

      expect(registered, true);
    });
  });
}
