package com.mjohnsullivan.flutterwear.wear

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.FlutterView

import android.app.Activity
import android.os.Bundle

import android.support.v4.view.ViewCompat.requestApplyInsets
import android.support.v4.view.ViewCompat.setOnApplyWindowInsetsListener
import android.support.v4.view.WindowInsetsCompat

import android.support.wear.ambient.AmbientMode

private const val CHANNEL_NAME = "wear"

fun getChannel(view: FlutterView): MethodChannel {
    return MethodChannel(view, CHANNEL_NAME)
}

class WearPlugin private constructor(
        activity: Activity,
        private val view: FlutterView,
        val channel: MethodChannel) :
        MethodCallHandler {

    private var mAmbientController: AmbientMode.AmbientController? = null

    init {
        // Set the Flutter ambient callbacks
        mAmbientController = AmbientMode.attachAmbientSupport(activity)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            channel.setMethodCallHandler(WearPlugin(registrar.activity(),
                    registrar.view(), channel))
        }
    }



    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "getPlatformVersion" ->
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            call.method == "getShape" -> handleShapeMethodCall(result)
            else -> result.notImplemented()
        }
    }

    private fun handleShapeMethodCall(result: Result) {
        setOnApplyWindowInsetsListener(view, { _, insets: WindowInsetsCompat? ->
            if (insets?.isRound == true) {
                result.success(0)
            } else {
                result.success(1)
            }
            WindowInsetsCompat(insets)
        })
        requestApplyInsets(view)
    }
}

/*
 * Pass ambient callback back to Flutter
 */
class FlutterAmbientCallback(private val channel: MethodChannel) : AmbientMode.AmbientCallback() {

    override fun onEnterAmbient(ambientDetails: Bundle) {
        channel.invokeMethod("enter", null)
        super.onEnterAmbient(ambientDetails)
    }

    override fun onExitAmbient() {
        channel.invokeMethod("exit", null)
        super.onExitAmbient()
    }

    override fun onUpdateAmbient() {
        channel.invokeMethod("update", null)
        super.onUpdateAmbient()
    }
}