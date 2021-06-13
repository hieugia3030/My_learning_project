import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:untitled/services/auth.dart';

class SignInManager{
  SignInManager({@required this.isLoading, @required this.auth});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod)  async{
    try{
      isLoading.value = true;
      return await signInMethod();
    } catch(e){
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async  => await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
}