import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget{
  PlatformAlertDialog({
    @required this.title,
  @required this.content,
    @required this.defaultActionText,
    this.cancelText,
  }) : assert(title != null), assert(content != null), assert(defaultActionText != null);
  final String title;
  final String content;
  final String defaultActionText;
  final String cancelText;

  Future<bool> show(BuildContext context) async {
    return !Platform.isIOS ? await showDialog<bool>(context: context, builder: (context) => this,) : await showCupertinoDialog<bool>(context: context, builder: (context) => this);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    // TODO: implement buildCupertinoWidget
   return CupertinoAlertDialog(
     title: Text(title),
     content: Text(content),
     actions: _buildAction(context),
   );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
   return AlertDialog(
     title: Text(title),
     content: Text(content),
     actions: _buildAction(context),
   );
  }

List<Widget> _buildAction (BuildContext context){
  List<Widget> actions = [];
  actions.add(
      PlatformAlertDialogAction( // để thay đổi cái action theo từng platform
        onPressed: () => Navigator.of(context).pop(true), // nếu pop(true) thì hàm sẽ được thực hiện nhưng luôn trả về giá trị kiểu bool là true trong mọi TH ***
        child: Text(defaultActionText),
      ),
    );
     if (cancelText != null) {
       actions.add(
           PlatformAlertDialogAction( // thêm nút cancel trong 1 số TH, ví dụ như khi ng dùng Sign out thì có thêm nút Cancel để xác nhận
         onPressed: () => Navigator.of(context).pop(false), // tương tự cái *** bên trên ;)
         child: Text(cancelText),
       )
       );
     }
     return actions;
}
}
class PlatformAlertDialogAction extends PlatformWidget{ // android và ios có nút action khác nhau
  PlatformAlertDialogAction({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    // TODO: implement buildCupertinoWidget
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    return TextButton(
        onPressed: onPressed,
        child: child
    );
  }
}
