import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/app/sign_in/validator.dart';
void main(){
  test('non empty String', () {
   final validator = NonEmptyStringValidator();
   expect(validator.isValid('value'), true);
  });

  test('Empty String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });

  test('Null String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}