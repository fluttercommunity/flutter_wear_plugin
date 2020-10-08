package com.mjohnsullivan.flutterwear.wear

import android.os.Bundle
import androidx.core.view.ViewCompat.getRootWindowInsets
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.google.android.wearable.compat.WearableActivityController
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class WearPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, LifecycleObserver {
    private var mAmbientCallback = WearableAmbientCallback()
    private var mMethodChannel: MethodChannel? = null
    private var mActivityBinding: ActivityPluginBinding? = null
    private var mAmbientController: WearableActivityController? = null

    companion object {
        const val TAG = "WearPlugin"
        const val BURN_IN_PROTECTION = WearableActivityController.EXTRA_BURN_IN_PROTECTION
        const val LOW_BIT_AMBIENT = WearableActivityController.EXTRA_LOWBIT_AMBIENT
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mMethodChannel = MethodChannel(binding.binaryMessenger, "wear")
        mMethodChannel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mMethodChannel?.setMethodCallHandler(this)
        mMethodChannel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        attachAmbientController(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        detachAmbientController()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        attachAmbientController(binding)
    }

    override fun onDetachedFromActivity() {
        detachAmbientController()
    }

    private fun attachAmbientController(binding: ActivityPluginBinding) {
        mActivityBinding = binding
        mAmbientController = WearableActivityController(TAG, binding.activity, mAmbientCallback)
        mAmbientController?.setAmbientEnabled()
        val reference = (binding.lifecycle as HiddenLifecycleReference)
        reference.lifecycle.addObserver(this)
    }

    private fun detachAmbientController() {
        mActivityBinding?.let {
            val reference = (it.lifecycle as HiddenLifecycleReference)
            reference.lifecycle.removeObserver(this)
        }
        mActivityBinding = null

    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getShape" -> {
                val activity = mActivityBinding?.activity
                when {
                    activity == null -> {
                        result.error("no-activity", "No android activity available.", null)
                    }
                    activity.resources.configuration.isScreenRound -> {
                        result.success("round")
                    }
                    else -> {
                        result.success("square")
                    }
                }
            }
            "isAmbient" -> {
                result.success(mAmbientController?.isAmbient ?: false)
            }
            "setAutoResumeEnabled" -> {
                val enabled = call.argument<Boolean>("enabled")
                if (mAmbientController == null || enabled == null) {
                    result.error("not-ready", "Ambient mode controller not ready", null)
                } else {
                    mAmbientController!!.setAutoResumeEnabled(enabled)
                    result.success(null)
                }
            }
            "setAmbientOffloadEnabled" -> {
                val enabled = call.argument<Boolean>("enabled")
                if (mAmbientController == null || enabled == null) {
                    result.error("not-ready", "Ambient mode controller not ready", null)
                } else {
                    mAmbientController!!.setAmbientOffloadEnabled(enabled)
                    result.success(null)
                }
            }
            else -> result.notImplemented()
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    fun onCreate() {
        mAmbientController?.onCreate()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    fun onResume() {
        mAmbientController?.onResume()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun onPause() {
        mAmbientController?.onPause()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onStop() {
        mAmbientController?.onStop()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onDestroy() {
        mAmbientController?.onDestroy()
    }

    inner class WearableAmbientCallback : WearableActivityController.AmbientCallback() {
        override fun onEnterAmbient(ambientDetails: Bundle) {
            val burnInProtection = ambientDetails.getBoolean(BURN_IN_PROTECTION, false)
            val lowBitAmbient = ambientDetails.getBoolean(LOW_BIT_AMBIENT, false)
            mMethodChannel?.invokeMethod("onEnterAmbient", mapOf(
                    "burnInProtection" to burnInProtection,
                    "lowBitAmbient" to lowBitAmbient
            ))
        }

        override fun onExitAmbient() {
            mMethodChannel?.invokeMethod("onExitAmbient", null)
        }

        override fun onUpdateAmbient() {
            mMethodChannel?.invokeMethod("onUpdateAmbient", null)
        }

        override fun onInvalidateAmbientOffload() {
            mMethodChannel?.invokeMethod("onInvalidateAmbientOffload", null)
        }
    }
}
