import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/app/sign_in/email_sign_in_change_model.dart';
import 'mock.dart';
void main(){
  MockAuth mockAuth;
  EmailSignInChangeModel model;

  setUp((){
    mockAuth = MockAuth();
    model = EmailSignInChangeModel(
      auth: mockAuth,
    );
  });

  test('update email', (){
    bool didNotifyListener = false;
    model.addListener(() => didNotifyListener = true);

    const sampleEmail = 'email@email.com';
    model.updateEmail(sampleEmail);
    expect(model.email, sampleEmail);
    expect(didNotifyListener, true);

    const samplePassword = 'abc';
    model.updatePassword(samplePassword);
    expect(model.password, samplePassword);

  });
}