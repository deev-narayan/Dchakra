import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // WEB & MOBILE (Android/iOS/MacOS) - Use GoogleSignIn for better UX
      if (kIsWeb || 
          defaultTargetPlatform == TargetPlatform.android || 
          defaultTargetPlatform == TargetPlatform.iOS || 
          defaultTargetPlatform == TargetPlatform.macOS) {
        
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      } 
      // DESKTOP (Windows/Linux) - Use OAuthProvider (Browser Flow)
      else {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithProvider(googleProvider);
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
}
