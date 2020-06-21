package com.mjohnsullivan.flutterwear.wearexample

import android.os.Bundle

import io.flutter.app.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant

import androidx.wear.ambient.AmbientModeSupport

import com.mjohnsullivan.flutterwear.wear.FlutterAmbientCallback
import com.mjohnsullivan.flutterwear.wear.WearPlugin
import com.mjohnsullivan.flutterwear.wear.getChannel

class EmbeddingV1Activity: FlutterFragmentActivity(), AmbientModeSupport.AmbientCallbackProvider {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    WearPlugin.registerWith(registrarFor("com.mjohnsullivan.flutterwear.wear.WearPlugin"))

    // Wire up the activity for ambient callbacks
    AmbientModeSupport.attach(this)
  }

  override fun getAmbientCallback(): AmbientModeSupport.AmbientCallback {
    return FlutterAmbientCallback(getChannel(flutterView))
  }
}
