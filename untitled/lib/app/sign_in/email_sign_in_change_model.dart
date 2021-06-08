import 'package:flutter/foundation.dart';
import 'package:untitled/app/sign_in/email_sign_in_model.dart';
import 'package:untitled/app/sign_in/validator.dart';
import 'package:untitled/services/auth.dart';


class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.auth,
        this.email = '',
      this.password = '',
      this.formType = EmailSignInType.signIn,
      this.isLoading = false,
      this.submitted = false,
      });
   final AuthBase auth;
   String email;
   String password;
   EmailSignInType formType;
   bool isLoading;
   bool submitted;

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    // TODO: Print email and password
    try{
      if (this.formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(this.email, this.password);
      }
    }  catch (e){
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText{
    return formType == EmailSignInType.signIn ? 'Đăng nhập' : 'Đăng kí';
  }
  String get secondaryButtonText{
    return  formType == EmailSignInType.register ? 'Đã có tài khoản? Đăng nhập' : 'Chưa có tài khoản? Đăng kí';
  }
  bool get canSubmit{
    return !isLoading && emailValidator.isValid(email) && passwordValidator.isValid(password);
  }
  String get emailErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }
  String get passwordErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType (){
    final formType = this.formType == EmailSignInType.signIn ? EmailSignInType.register : EmailSignInType.signIn;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      formType: formType,
      isLoading : false,
    );
  }

  void updateWith({
  String email,
    String password,
    EmailSignInType formType,
    bool isLoading,
    bool submitted,
}){
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
}
}
