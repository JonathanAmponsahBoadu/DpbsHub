import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thrown when cloud sync is used before Firebase has been wired up (i.e.
/// before `google-services.json` is in place and `Firebase.initializeApp()`
/// runs in `main()`). The UI should catch this and show a setup prompt
/// instead of a raw crash.
class CloudSyncNotConfiguredException implements Exception {
  const CloudSyncNotConfiguredException();
  @override
  String toString() =>
      'Cloud sync isn\'t set up yet — Firebase hasn\'t been configured for this build.';
}

/// A sign-in failure with a message written for a human rather than a raw
/// platform exception. [cancelled] means you simply backed out of the
/// Google account picker — nothing to report.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.cancelled = false});
  final String message;
  final bool cancelled;

  @override
  String toString() => message;
}

/// Wraps Google Sign-In + Firebase Auth for the account/cloud-sync feature.
/// Nothing here touches your Bible study data directly — [SyncService] does
/// that once you're signed in. Signing out never deletes anything locally.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _initialized = false;

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    // No explicit serverClientId: on Android this is auto-read from
    // google-services.json (the "default_web_client_id" resource generated
    // by the Google Services Gradle plugin) once that file is in place.
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  Future<User> signInWithGoogle() async {
    await _ensureInitialized();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      throw _explain(e);
    }

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw const AuthFailure(
        'Google signed you in but returned no ID token. This usually means the web '
        'client ID is missing from google-services.json — enable Google sign-in in '
        'Firebase Authentication, download google-services.json again, and rebuild.',
      );
    }

    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure('Firebase rejected the sign-in (${e.code}): ${e.message ?? 'no details'}');
    }
  }

  AuthFailure _explain(GoogleSignInException e) {
    final detail = e.description == null || e.description!.isEmpty ? '' : ' (${e.description})';
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled =>
        const AuthFailure('Sign-in cancelled.', cancelled: true),
      GoogleSignInExceptionCode.interrupted =>
        const AuthFailure('Sign-in was interrupted — please try again.'),
      GoogleSignInExceptionCode.uiUnavailable => const AuthFailure(
          "Couldn't show the Google sign-in screen. Keep the app in the foreground and try again."),
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError =>
        AuthFailure(
          "Google sign-in isn't configured correctly for this build$detail. Check that "
          'google-services.json is in android/app and that this build was rebuilt after adding it.',
        ),
      _ => AuthFailure(
          'Google sign-in failed$detail.\n\n'
          'The two usual causes: (1) no Google account is added on this phone, or '
          "(2) this build's SHA-1/SHA-256 fingerprint isn't registered in Firebase "
          '(Project settings → Your apps → Add fingerprint), followed by downloading '
          'google-services.json again and rebuilding.',
        ),
    };
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Not fatal — Firebase sign-out already ended the app session.
    }
  }
}
