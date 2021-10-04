import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum LoginState { Success, UserNotFound, InvalidEmail, Failure, WrongPassword }
enum LogOutState { Exit }
enum RegisterState {
  Success,
  WeakPassword,
  EmailAlreadyInUse,
  InvalidEmail,
  Unknown,
  Failure
}
enum ForgotState { Failure, UserNotFound, InvalidEmail, Success }

class AuthenticationRepository {
  // create new instance for firebase authentication
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // create new instance for Cloud FireStore
  // Methods Firebase login
  // ignore: missing_return
  Future<LoginState> login(
      {@required String email, @required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return LoginState.Success;
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        return LoginState.UserNotFound;
      }else if (e.code == "invalid-email") {
        return LoginState.InvalidEmail;
      } else if (e.code == "wrong-password") {
        print("Wrong Password ${e.code}");
        return LoginState.WrongPassword;
      } else {
        print(e.code);
        return LoginState.Failure;
      }

    }
  }

  // Sign Up or Register New User or Create New Account
  Future<RegisterState> register(
      {@required String email,
      @required String password,}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await _createNewUserPaid(data, userId.user.uid);
      return RegisterState.Success;
    } on FirebaseException catch  (e) {
      if (e.code == "weak-password") {
        return RegisterState.WeakPassword;
      } else if (e.code == "email-already-in-use") {
        return RegisterState.EmailAlreadyInUse;
      } else if (e.code == "invalid-email") {
        return RegisterState.InvalidEmail;
      } else if (e.code == "unknown") {
        return RegisterState.Unknown;
      } else {
        print(e.code);
        return RegisterState.Failure;
      }
    }
  }

  // Closed Account And SingOut And out unside account
  Future<LogOutState> signOut() async {
    await _firebaseAuth.signOut();
    return LogOutState.Exit;
  }

  // // Forgot Password but you can of user creaet new password by this method
  Future<ForgotState> forgotPassword({@required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Ok');
      return ForgotState.Success;
    } on FirebaseException catch  (e) {
      if (e.code == "invalid-email") {
        return ForgotState.InvalidEmail;
      } else if (e.code == "user-not-found") {
        return ForgotState.UserNotFound;
      } else {
        return ForgotState.Failure;
      }
    }
  }

}
