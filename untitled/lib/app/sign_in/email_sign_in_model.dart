import 'package:untitled/app/sign_in/validator.dart';

enum EmailSignInType{
  signIn,
  register
}
class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInType.signIn,
      this.isLoading = false,
      this.submitted = false,
      });

  final String email;
  final String password;
  final EmailSignInType formType;
  final bool isLoading;
  final bool submitted;

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
  EmailSignInModel copyWith({
  String email,
    String password,
    EmailSignInType formType,
    bool isLoading,
    bool submitted,
}){
  return EmailSignInModel(
    email: email ?? this.email,
    password: password ?? this.password,
    formType: formType ?? this.formType,
    isLoading: isLoading ?? this.isLoading,
    submitted: submitted ?? this.submitted,
  );
}
}
