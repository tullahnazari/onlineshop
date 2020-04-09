import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweepstakes/models/http_exception.dart';
import 'package:sweepstakes/providers/user_table_roles.dart';

class Auth with ChangeNotifier {
  var loggedIn = false;
  var firebaseAuth = FirebaseAuth.instance;
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  //verifies if user is authorized
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  bool isAdmin;

  //reusable in two endpoints with parameters
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCmLH-IxHIPUR0XsPJ5U_R_bE1MbTOwH0I';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return await _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'signInWithPassword');
  }

  // void initiateSignIn(String type) {
  //   _handleSignIn(type).then((result) {
  //     if (result == 1) {
  //       // setState(() {
  //       loggedIn = true;
  //       // });
  //     } else {}
  //   });
  // }

  // Future<int> _handleSignIn(String type) async {
  //   switch (type) {
  //     case "FB":
  //       FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
  //       final accessToken = facebookLoginResult.accessToken.token;
  //       if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
  //         final facebookAuthCred =
  //             FacebookAuthProvider.getCredential(accessToken: accessToken);
  //         final user =
  //             await firebaseAuth.signInWithCredential(facebookAuthCred);
  //         print("User : " + user.additionalUserInfo.username);
  //         return 1;
  //       } else
  //         return 0;
  //       break;
  //     case "G":
  //       try {
  //         GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
  //         final googleAuth = await googleSignInAccount.authentication;
  //         final googleAuthCred = GoogleAuthProvider.getCredential(
  //             idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  //         final user = await firebaseAuth.signInWithCredential(googleAuthCred);
  //         print("User : " + user.additionalUserInfo.username);
  //         return 1;
  //       } catch (error) {
  //         return 0;
  //       }
  //   }
  //   return 0;
  // }

  // Future<FacebookLoginResult> _handleFBSignIn() async {
  //   FacebookLogin facebookLogin = FacebookLogin();
  //   FacebookLoginResult facebookLoginResult =
  //       await facebookLogin.logIn(['email']);
  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("Cancelled");
  //       break;
  //     case FacebookLoginStatus.error:
  //       print("error");
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       print("Logged In");
  //       break;
  //   }
  //   return facebookLoginResult;
  // }

  // Future<GoogleSignInAccount> _handleGoogleSignIn() async {
  //   GoogleSignIn googleSignIn = GoogleSignIn(
  //       scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
  //   GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   return googleSignInAccount;
  // }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
