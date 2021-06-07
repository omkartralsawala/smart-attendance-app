import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_app/models/user.dart';

abstract class AuthBase {
  Stream<UserModel?> onAuthStateChanged(String userType);
  // Future<UserModel?> currentUser();
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password, String userType);
  Future<UserModel?> createUserWithEmailAndPassword(
      String userType, String email, String password);
  // Future<UserModel?> signInWithGoogle(String userType);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user, String userType) {
    if (user == null) {
      return null;
    }
    return UserModel(
      userType: userType,
      uid: user.uid,
      name: user.displayName,
      email: user.email,
    );
  }

  @override
  Stream<UserModel?> onAuthStateChanged(String userType) {
    _firebaseAuth.authStateChanges();
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFirebase(user, userType));
  }

  // @override
  // Future<UserModel?> currentUser() async {
  //   final user = _firebaseAuth.currentUser;
  //   return _userFromFirebase(user, );
  // }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password, String userType) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (authResult.user!.emailVerified) {
      return _userFromFirebase(authResult.user, userType);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password, String userType) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    try {
      await authResult.user!.sendEmailVerification();
      return _userFromFirebase(authResult.user, userType);
    } catch (e) {
      print("An error occured while trying to send email verification");
    }
    return null;
  }

  // @override
  // Future<UserModel?> signInWithGoogle(String userType) async {
  //   final googleSignIn = GoogleSignIn();
  //   final googleAccount = await googleSignIn.signIn();
  //   if (googleAccount != null) {
  //     final googleAuth = await googleAccount.authentication;
  //     if (googleAuth.idToken != null && googleAuth.accessToken != null) {
  //       final authResult = await _firebaseAuth.signInWithCredential(
  //         GoogleAuthProvider.credential(
  //           idToken: googleAuth.idToken,
  //           accessToken: googleAuth.accessToken,
  //         ),
  //       );
  //       return _userFromFirebase(authResult.user, userType);
  //     } else {
  //       throw PlatformException(
  //         code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //         message: 'Missing Google Auth token',
  //       );
  //     }
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: 'Sign in aborted by user',
  //     );
  //   }
  // }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
