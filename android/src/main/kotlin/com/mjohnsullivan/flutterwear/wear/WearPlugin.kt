package com.mjohnsullivan.flutterwear.wear

import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.core.view.ViewCompat.requestApplyInsets
import androidx.core.view.ViewCompat.setOnApplyWindowInsetsListener
import androidx.core.view.WindowInsetsCompat
import androidx.fragment.app.FragmentActivity
import androidx.wear.ambient.AmbientModeSupport
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.FlutterView

private const val CHANNEL_NAME = "wear"

fun getChannel(view: FlutterView): MethodChannel {
    return MethodChannel(view, CHANNEL_NAME)
}

fun getChannel(flutterEngine: FlutterEngine?): MethodChannel {
    return MethodChannel(
        flutterEngine?.dartExecutor?.binaryMessenger
            ?: throw RuntimeException("flutterEngine was null"),
        CHANNEL_NAME
    )
}

class WearPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var view: View
    private lateinit var mAmbientController: AmbientModeSupport.AmbientController

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            val plugin = WearPlugin()
            plugin.onAttachedToActivity(registrar.activity() as FragmentActivity)
            channel.setMethodCallHandler(plugin)
        }
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" ->
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "getShape" -> handleShapeMethodCall(result)
            else -> result.notImplemented()
        }
    }

    private fun handleShapeMethodCall(result: Result) {
        setOnApplyWindowInsetsListener(view) { _, insets: WindowInsetsCompat? ->
            if (insets?.isRound == true) {
                result.success(0)
            } else {
                result.success(1)
            }
            WindowInsetsCompat(insets)
        }
        requestApplyInsets(view)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding.activity as FragmentActivity)
    }

    private fun onAttachedToActivity(activity: FragmentActivity) {
        mAmbientController = AmbientModeSupport.attach(activity)
        view = ActivityCompat.requireViewById<ViewGroup>(activity, android.R.id.content)
            .getChildAt(0)
    }

    override fun onDetachedFromActivityForConfigChanges() {}
}

/*
 * Pass ambient callback back to Flutter
 */
class FlutterAmbientCallback(private val channel: MethodChannel) :
    AmbientModeSupport.AmbientCallback() {

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