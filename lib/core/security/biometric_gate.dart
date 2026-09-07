import 'package:local_auth/local_auth.dart';

/// Fingerprint/face (falling back to device PIN/pattern) gate placed in
/// front of the AI Providers screen — nothing else in the app requires it.
class BiometricGate {
  BiometricGate._();
  static final instance = BiometricGate._();

  final _auth = LocalAuthentication();

  /// Returns true if the device has no usable lock at all (no biometrics,
  /// no PIN/pattern/password set up) — in that case there's nothing to gate
  /// behind, so callers should let the user through with a warning instead
  /// of trapping them out of a feature they can't unlock.
  Future<bool> hasNoDeviceSecurity() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return !supported && !canCheck;
    } catch (_) {
      return true;
    }
  }

  Future<bool> authenticate({String reason = 'Unlock your AI provider settings'}) async {
    if (await hasNoDeviceSecurity()) return true;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
      );
    } catch (_) {
      return false;
    }
  }
}
