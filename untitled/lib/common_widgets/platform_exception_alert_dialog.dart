import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:untitled/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception
  }) : super(
    title: title,
    content: _message(exception),
    defaultActionText: 'OK',
  );
  static String _message (PlatformException e){
    if(e.code == 'Error performing setData'){
      if(e.message == 'PERMISSION_DENIED: Missing or insufficient permissions.'){
        return 'Lỗi khi kết nối với server, xin hãy thử lại lần sau';
      }
    }
    return _errors[e.code] ??  e.message;
  }
  static Map <String , String> _errors = {
     'ERROR_INVALID_EMAIL' : 'Email không hợp lệ, xin mời bạn nhập lại',
     'ERROR_WRONG_PASSWORD' :' Mật khẩu sai, xin mời bạn nhập lại',
     'ERROR_USER_NOT_FOUND' : 'Tài khoản không tồn tại, xin hãy chọn tài khoản khác hoặc đăng kí phía bên dưới',
     'ERROR_USER_DISABLED' : 'Tài khoản đã bị vô hiệu hóa, xin hãy chọn tài khoản khác',
     'ERROR_TOO_MANY_REQUESTS' : 'Bạn đang nhấn quá nhiều lần, xin hày nhấn chậm lại',
     'ERROR_OPERATION_NOT_ALLOWED' : 'Xin lỗi , chúng tôi chưa hỗ trợ đăng nhập bằng email, xin hãy thử lại sau ',
     'ERROR_WEAK_PASSWORD' : 'Mật khẩu chưa đủ mạnh, hãy thêm chữ cái, kí tự đặc biệt vào mật khẩu ',
    'ERROR_EMAIL_ALREADY_IN_USE': 'Email đã được sử dụng cho 1 tài khoản khác',
};
}
