package com.mjohnsullivan.flutterwear.wearexample

import androidx.wear.ambient.AmbientModeSupport

import com.mjohnsullivan.flutterwear.wear.FlutterAmbientCallback
import com.mjohnsullivan.flutterwear.wear.getChannel

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity(), AmbientModeSupport.AmbientCallbackProvider {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    override fun getAmbientCallback(): AmbientModeSupport.AmbientCallback {
        return FlutterAmbientCallback(getChannel(flutterEngine))
    }
}
