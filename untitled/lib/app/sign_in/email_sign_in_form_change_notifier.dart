import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/email_sign_in_change_model.dart';
import 'package:untitled/common_widgets/form_submit_button.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController =
      TextEditingController(); // kiểm soát các textfield, ví dụ lấy text tù đó: _emailController.text, hay xóa : _emailController.clear();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // TODO: Print email and password
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        exception: e,
        title: 'Đăng nhập thất bại',
      ).show(context);
    }
  }

  void _toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _onEditingEmailComplete() {
    final newNode = widget.model.emailValidator.isValid(widget.model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newNode);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: widget.model.primaryButtonText,
        onPressed: widget.model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      TextButton(
        child: Text(
          widget.model.secondaryButtonText,
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
        onPressed: widget.model.isLoading ? null : _toggleFormType,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: widget.model.emailErrorText,
        enabled: widget.model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.model.updateEmail,
      onEditingComplete: () => _onEditingEmailComplete(),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '123456',
        errorText: widget.model.passwordErrorText,
        enabled: widget.model.isLoading == false,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: widget.model.updatePassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
