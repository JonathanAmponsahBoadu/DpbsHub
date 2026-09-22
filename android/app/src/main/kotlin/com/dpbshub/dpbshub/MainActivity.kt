package com.dpbshub.dpbshub

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth for
// the biometric prompt (fingerprint/face) used to lock the AI API key vault.
class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (isScreenWakeLaunch(intent)) finish()
    }

    override fun onNewIntent(intent: Intent) {
        // The app is already running: leave it exactly as it was.
        if (isScreenWakeLaunch(intent)) return
        super.onNewIntent(intent)
    }

    /**
     * Reminders are "full-screen intent" notifications so that they light up
     * a sleeping screen. Android implements that by *launching this activity*
     * behind the lock screen, so without this check the app would pop open
     * the moment you unlock your phone.
     *
     * Telling that launch apart from you tapping the notification: a tap on a
     * secured lock screen only starts the activity after you've unlocked, so
     * the device is no longer locked by then. If it is still locked, this is
     * the wake-up launch and should not show anything — the screen has
     * already been lit, which was the whole point.
     */
    private fun isScreenWakeLaunch(intent: Intent?): Boolean {
        if (intent?.action != "SELECT_NOTIFICATION") return false
        val keyguard = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        return keyguard.isDeviceLocked
    }
}
