// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:alternate_store/model/user_model.dart';

import 'auth_database.dart';

class AuthService extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  //  獲取用戶登入狀態
  bool get isSignedIn => _auth.currentUser != null;

  //  獲取用戶 ID
  String get userUid => _auth.currentUser != null ? _auth.currentUser.uid : '';

  //  獲取用戶電郵驗証狀態
  bool get emailverify => isSignedIn == true ? _auth.currentUser.emailVerified : null;

  //  以電郵登入
  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  //  以電郵註冊
  Future<String> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        AuthDatabase(value.user.uid).createUserInfo(
          UserModel(Timestamp.now(), '', email, email.split('@')[0].toUpperCase(), '', '', '', '', '', ''),
        );
      });
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  //  發送重置密碼電郵
  Future<String> passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  //  發送驗証電郵
  Future<void> sendEmailVerification() async {
    _auth.currentUser.sendEmailVerification();
  }

  //  以 Facebook 登入
  //  TODO Login with facebook

  //  以 Google 登入
  //  TODO Login with Google

  //  以 Apple 登入
  //  TODO Login with Apple

  //  登出
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  
}
