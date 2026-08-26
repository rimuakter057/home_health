// import 'package:google_sign_in/google_sign_in.dart';
//
// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: ['email'],
// );
//
// Future<void> signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//   if (googleUser == null) {
//     return;
//   }
//
//   final GoogleSignInAuthentication googleAuth =
//   await googleUser.authentication;
//
//   String? idToken = googleAuth.idToken;
//
//   await sendTokenToBackend(idToken);
// }