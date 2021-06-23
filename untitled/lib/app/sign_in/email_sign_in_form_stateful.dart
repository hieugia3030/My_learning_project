import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/email_sign_in_model.dart';
import 'package:untitled/app/sign_in/validator.dart';
import 'package:untitled/common_widgets/form_submit_button.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidator{
   EmailSignInFormStateful({Key key, this.onSignedIn, this.onRegistered}) : super(key: key);
  final VoidCallback onSignedIn;
  final VoidCallback onRegistered;
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}


class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {

   EmailSignInType _formType = EmailSignInType.signIn;

  final TextEditingController _emailController = TextEditingController();  // kiểm soát các textfield, ví dụ lấy text tù đó: _emailController.text, hay xóa : _emailController.clear();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

   String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submited = false;
  bool _isLoading = false;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    setState(() {
      _isLoading = true;
      _submited = true;
    });
    // TODO: Print email and password
    try{
      final auth = Provider.of<AuthBase>(context, listen: false) ;
      if (_formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
        if(widget.onSignedIn != null){
          widget.onSignedIn();
        }
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
        if(widget.onRegistered != null){
          widget.onRegistered();
        }
      }

    } on PlatformException catch (e){
      PlatformExceptionAlertDialog(
        exception : e,
        title: 'Đăng nhập thất bại',
      ).show(context);
    } finally{
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = false;
    });
    }
  }

  void _toggleFormType(){
    setState(() {
      _submited = false;
      _formType = _formType == EmailSignInType.signIn ? EmailSignInType.register : EmailSignInType.signIn;
    });
    _emailController. clear();
    _passwordController.clear();
  }

  void _onEditingEmailComplete (){
    final newNode = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newNode);
  }
  List<Widget> _buildChildren(){
    String  primaryText = (_formType == EmailSignInType.signIn) ? 'Đăng nhập' : 'Đăng kí';
    String secondaryText = (_formType == EmailSignInType.register) ? 'Đã có tài khoản? Đăng nhập' : 'Chưa có tài khoản? Đăng kí';

    bool submitEnabled = !_isLoading && widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password); // kiểm tra xem email và password có đúng mẫu ko?????

    return [
      _buildEmailTextField(),

      SizedBox(height: 8.0),

      _buildPasswordTextField(),

      SizedBox(height: 8.0),

      FormSubmitButton(
          text: primaryText,
          onPressed: submitEnabled ?  _submit : null,
      ),

      SizedBox(height: 8.0),

      TextButton(
        child: Text(
            secondaryText,
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
        onPressed: _isLoading ? null : _toggleFormType,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submited && !widget.emailValidator.isValid(_email);
    return TextField(
      key: Key('email'),
      controller: _emailController,
    focusNode: _emailFocusNode,
    decoration: InputDecoration(
      labelText: 'Email',
      hintText: 'test@test.com',
      errorText: showErrorText ?  widget.invalidEmailErrorText : null ,
      enabled: _isLoading == false,
    ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _onEditingEmailComplete,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submited && !widget.passwordValidator.isValid(_password);
    return TextField(
      key: Key('password'),
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '123456',
        errorText: showErrorText ?   widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
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

void  _updateState() {
    setState(() {});
}
}

