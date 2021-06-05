
class FailedSignInAlert{
  FailedSignInAlert({this.string});
  String string;
  String _findErrorSubString(String string){
    int firstComma = 0; // dấu phẩy đầu tiên  bởi vì cái lỗi sẽ trông ntn trên console: PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)
    int nextDot = 0; // dấu chấm tiếp theo
    for (int i=0; i< string.length; ++i){
      if(string[i] == ',') {
        firstComma = i;
        for (int j = i+20; j<string.length; ++j){
          if(string[j] == '.') {
            nextDot = j;
            break;
          }
        }
        break;
      }
    }
    return string.substring(firstComma + 2, nextDot);
  }
  String showAlertString (String errorString) {
    String s = _findErrorSubString(errorString);
    switch(s){
      case 'The email address is badly formatted':
        return 'email không hợp lệ, xin hãy nhập lại';
        break;
      case 'There is no user record corresponding to this identifier':
        return 'email hoặc mật khẩu không đúng';
        break;
    }
  }
  }
