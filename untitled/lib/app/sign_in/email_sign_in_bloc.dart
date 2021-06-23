import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:untitled/app/sign_in/email_sign_in_model.dart';
import 'package:untitled/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;

  final _modelSubject =  BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    try{
      if (_model.formType == EmailSignInType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    }  catch (e){
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType (){
    final formType = _model.formType == EmailSignInType.signIn ? EmailSignInType.register : EmailSignInType.signIn;
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
  }) {
    // update model
    //add updated model to _modelController
    _modelSubject.value = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
  }
}
