import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/app/sign_in/email_sign_in_bloc.dart';
import 'package:untitled/app/sign_in/email_sign_in_model.dart';
import 'package:untitled/common_widgets/form_submit_button.dart';
import 'package:untitled/common_widgets/platform_exception_alert_dialog.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
   EmailSignInFormBlocBased({Key key, @required this.bloc}) : super(key: key);
   final EmailSignInBloc bloc;

   static Widget create(BuildContext context){
     final auth = Provider.of<AuthBase>(context, listen: false);
     return Provider(
         create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
          builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
     ),
       dispose: (context, bloc) => bloc.dispose(),
     );
   }


  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}


class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {


  final TextEditingController _emailController = TextEditingController();  // kiểm soát các textfield, ví dụ lấy text tù đó: _emailController.text, hay xóa : _emailController.clear();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();



  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async{

    // TODO: Print email and password
    try{
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e){
      PlatformExceptionAlertDialog(
        exception : e,
        title: 'Đăng nhập thất bại',
      ).show(context);
    }
  }

  void _toggleFormType(){
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _onEditingEmailComplete (EmailSignInModel model){
    final newNode = model.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newNode);
  }
  List<Widget> _buildChildren(EmailSignInModel model){


    return [
      _buildEmailTextField(model),

      SizedBox(height: 8.0),

      _buildPasswordTextField(model),

      SizedBox(height: 8.0),

      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ?  _submit : null,
      ),

      SizedBox(height: 8.0),

      TextButton(
        child: Text(
          model.secondaryButtonText,
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
        onPressed: model.isLoading ? null :  _toggleFormType,
      ),
    ];

  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _onEditingEmailComplete(model),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '123456',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildChildren(model),
              ),
            );
          }
        );
      }


  }




