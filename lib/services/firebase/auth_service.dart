import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkourspotkorea/screens/auth/login_page.dart';


class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //현재 로그인된 사용자 확인
  firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

  //회원가입
  Future<firebase_auth.User?> signup({
    required String email,
    required String password,
    required String displayName,
    required String parkourProficiency,
    required int phoneNum,
  }) async {
    try {
      ///1. Firebase Auth 회원가입
      firebase_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase_auth.User? firebaseUser = result.user;
      if (firebaseUser != null) {
        /// 2. Firebase 프로필 업데이트
        await firebaseUser.updateDisplayName(displayName);

        /// 3. 로컬 DB에 사용자 생성
        await _createLocalUser(
          firebaseUser: firebaseUser,
          displayName: displayName,
          parkourProficiency: parkourProficiency,
          phoneNum: phoneNum,
        );
        print('회원가입 완료:${firebaseUser.email}');
        return firebaseUser;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = '회원가입에 실패했습니다.';
      if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 사용중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        message = '유효하지 않은 이메일입니다.';
      }
      print('회원가입 오류:${e.message}');


      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('예상치 못한 오류: $e');
    }
    return null;
  }

  //로그인
  Future<firebase_auth.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      //1. Firebase Auth 로그인

      firebase_auth.UserCredential result = await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? firebaseUser = result.user;
      if (firebaseUser != null) {
        //2. 로컬 DB 사용자 확인/생성
        await _ensureLocalUserExists(firebaseUser);
        print('✅ 로그인 완료: ${firebaseUser.email}');
      }

      return firebaseUser;

    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = '존재하지 않는 아이디입니다.';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호가 틀렸습니다.';
      }
      //print(e.code);

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      //throw Exception('login error');
      return null;
    } catch (e) {
      print('예기치 못한 로그인 오류: $e');
      return null;
    }
  }

  //로그아웃
  Future<void> signOut({required BuildContext context}) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    );
  }

  //사용자 상태 확인
  Future<void> checkUserOnAppStart() async {
    firebase_auth.User? firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      // 이미 로그인되어 있다면 로컬 DB에도 사용자가 있는지 확인
      await _ensureLocalUserExists(firebaseUser);
      print('✅ 기존 로그인 사용자 확인 완료: ${firebaseUser.email}');
    }
  }

  ///회원가입 시 로컬 DB에 새 사용자 생성
  Future<void> _createLocalUser({
    required firebase_auth.User firebaseUser,
    required String displayName,
    required String parkourProficiency,
    required int phoneNum,
  }) async {
    try {
      // 현재 위치 가져오기 (기본값으로 서울시청)


      print('🎯 로컬 DB 사용자 생성 완료: $displayName');
    } catch (e) {
      print('❌ 로컬 DB 사용자 생성 오류: $e');
    }
  }

  ///로컬 DB에 사용자가 있는지 확인하고 없으면 생성(로그인 시)
  Future<void> _ensureLocalUserExists(firebase_auth.User firebaseUser) async {

  }
}
