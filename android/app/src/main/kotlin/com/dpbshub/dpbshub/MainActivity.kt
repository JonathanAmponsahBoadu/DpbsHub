package com.dpbshub.dpbshub

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth for
// the biometric prompt (fingerprint/face) used to lock the AI API key vault.
class MainActivity : FlutterFragmentActivity()
