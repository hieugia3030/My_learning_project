

abstract class StringValidator{
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator{
    @override
  bool isValid(String value){
      if (value == null) {
        return false;
      }
      return value.isNotEmpty;
    }
}

class EmailAndPasswordValidator{
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email không thể để trống';
  final String invalidPasswordErrorText = 'Mật khẩu không thể để trống';
}