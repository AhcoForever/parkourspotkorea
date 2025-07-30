import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkourspotkorea/screens/login_page.dart';
import 'package:parkourspotkorea/services/user_service.dart';

import '../database/app_database.dart';

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
      return null;
    } catch (e) {
      print('예기치 못한 로그인 오류: $e');
      return null;
    }
  }

  //구글 로그인
  // Future<firebase_auth.User?> signInWithGoogle() async {
  //   try {
  //     // 1. 구글 로그인
  //     //final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return null;
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // 2. Firebase 인증
  //     final credential = firebase_auth.GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     firebase_auth.UserCredential result = await _auth.signInWithCredential(credential);
  //     firebase_auth.User? firebaseUser = result.user;
  //
  //     if (firebaseUser != null) {
  //       // 3.  로컬 DB 사용자 확인/생성
  //       await _ensureLocalUserExists(firebaseUser);
  //
  //       print('✅ 구글 로그인 완료: ${firebaseUser.email}');
  //       return firebaseUser;
  //     }
  //   } catch (e) {
  //     print('❌ 구글 로그인 오류: $e');
  //     throw e;
  //   }
  //   return null;
  // }

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
      //TODO: 사용자 현재 위치로 변경
      double defaultLat = 37.5326;
      double defaultLng = 126.9906;

      // 🎯 로컬 DB에 사용자 생성
      await UserService.createUser(
        uid: firebaseUser.uid,           // Firebase UID 사용
        email: firebaseUser.email ?? '',
        displayName: displayName,
        parkourProficiency: parkourProficiency,
        phoneNum: phoneNum,
        latitude: defaultLat,
        longitude: defaultLng,
      );

      print('🎯 로컬 DB 사용자 생성 완료: $displayName');
    } catch (e) {
      print('❌ 로컬 DB 사용자 생성 오류: $e');
    }
  }

  ///로컬 DB에 사용자가 있는지 확인하고 없으면 생성(로그인 시)
  Future<void> _ensureLocalUserExists(firebase_auth.User firebaseUser) async {
    try {
      // 1. 로컬 DB에서 사용자 찾기
      LocalUser? localUser = await UserService.getUser(firebaseUser.uid);

      if (localUser == null) {
        // 2. 없으면 기본값으로 생성 (구글 로그인 등에서 발생 가능)
        await UserService.createUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '예비닉네임',
          parkourProficiency: '초급', // 기본값
          phoneNum: 0,                // 기본값 (나중에 업데이트)
          latitude: 37.5326,          // 서울시청 기본값
          longitude: 126.9906,
        );

        print('🎯 로컬 사용자 자동 생성: ${firebaseUser.displayName}');
      } else {
        // 3. 있으면 마지막 로그인 시간 업데이트
        await UserService.updateUser(
          firebaseUser.uid,
          // lastLogin은 UserService에서 자동으로 업데이트됨
        );

        print('🔄 기존 로컬 사용자 로그인 시간 업데이트');
      }
    } catch (e) {
      print('❌ 로컬 사용자 확인/생성 오류: $e');
    }
  }
}

