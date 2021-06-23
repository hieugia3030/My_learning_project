import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/app/sign_in/sign_in_manager.dart';
import 'package:untitled/services/auth.dart';
import 'mock.dart';

class MockValueNotifier<T> extends ValueNotifier<T>{
  MockValueNotifier(T value) : super(value);

  List<T> values = [];
  @override
  set value(T newValue) {
    values.add(newValue);
   super.value = newValue;
  }
}
void main(){
  MockAuth mockAuth;
  SignInManager manager;
  MockValueNotifier<bool> isLoading;

  setUp((){
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    manager = SignInManager(isLoading: isLoading, auth: mockAuth);
  });

  test('signed in success', () async{
    when(mockAuth.signInAnonymously()).thenAnswer((_) => Future<User>.value(User(uid:'abc')));
    await manager.signInAnonymously();
    expect(isLoading.values, [true]);
  });

  test('signed in failed', () async{
    when(mockAuth.signInAnonymously()).thenThrow(PlatformException(code: 'Failed', message: 'sign in is failed'));
    try {
      await manager.signInAnonymously();
    } catch (e) {
      expect(isLoading.values, [true, false]);
    }
  });
}