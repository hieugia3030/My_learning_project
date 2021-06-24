import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/app/sign_in/email_sign_in_bloc.dart';
import 'package:untitled/app/sign_in/email_sign_in_model.dart';
import 'mock.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  tearDown(() {
    bloc.dispose();
  });

  test(
      'When email is updated and password is updated,'
      ' submit is call, '
      'modelStream emit the correct event ', () async {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'a'));
    expect(bloc.modelStream, emits(EmailSignInModel()));

    bloc.updateEmail('email@email.com');
    expect(bloc.modelStream, emits(EmailSignInModel(email: 'email@email.com')));

    bloc.updatePassword('password');
    expect(
        bloc.modelStream,
        emits(
            EmailSignInModel(email: 'email@email.com', password: 'password')));
    try{
      await bloc.submit();
    } catch (_){
      expect(bloc.modelStream, emitsInOrder(
        [
      EmailSignInModel(
          email: 'email@email.com',
          password: 'password',
          submitted: true,
        isLoading: true,
      ),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
            submitted: true,
            isLoading: false,
          ),
    ]
      ));
    }
  });
}
