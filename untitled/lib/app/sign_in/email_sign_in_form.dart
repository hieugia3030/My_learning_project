import 'package:flutter/material.dart';
import 'package:untitled/app/sign_in/validator.dart';
import 'package:untitled/common_widgets/form_submit_button.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator{
  EmailSignInForm({this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

enum EmailSignInType{
  signIn,
  register
}
class _EmailSignInFormState extends State<EmailSignInForm> {

   EmailSignInType _formType = EmailSignInType.signIn;

  final TextEditingController _emailController = TextEditingController();  // kiểm soát các textfield, ví dụ lấy text tù đó: _emailController.text, hay xóa : _emailController.clear();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

   String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submited = false;
  bool _isLoading = false;

  void _submit() async{
    setState(() {
      _isLoading = true;
      _submited = true;
    });
    // TODO: Print email and password
    try{
      if (_formType == EmailSignInType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e){
      print(e.toString());
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
    _emailController.clear();
    _passwordController.clear();
  }
  List<Widget> _buildChildren(){
    String  primaryText = (_formType == EmailSignInType.signIn) ? 'Sign In' : 'Register';
    String secondaryText = (_formType == EmailSignInType.register) ? 'Had an account? Sign in' : 'Need an account? Register';

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
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submited && !widget.passwordValidator.isValid(_password);
    return TextField(
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

