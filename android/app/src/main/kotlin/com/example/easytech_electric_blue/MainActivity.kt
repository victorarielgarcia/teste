package com.example.easytech_electric_blue

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import androidx.annotation.NonNull
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/lockTask"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "unlockTaskMode") {
                unlockTaskMode()
                result.success(null)
            } else if (call.method == "lockTaskMode") {
                lockTaskMode()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        lockTaskMode()
    }

    private fun unlockTaskMode() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            stopLockTask() // referindo-se diretamente ao método da Activity
        }
    }

    private fun lockTaskMode() {
        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val adminName = ComponentName(this, AdminReceiver::class.java)

        if (dpm.isDeviceOwnerApp(packageName)) {
            val packages = arrayOf(packageName)
            dpm.setLockTaskPackages(adminName, packages)
            if (dpm.isLockTaskPermitted(packageName) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                startLockTask() // referindo-se diretamente ao método da Activity
            }
        }
    }
}
