package rjm.status.videostatus

import android.content.ContentValues
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.provider.MediaStore
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel

import io.flutter.plugins.GeneratedPluginRegistrant
import android.R.attr.path
import android.annotation.TargetApi
import android.net.Uri
import android.os.Build
import java.io.File
import android.os.StrictMode




class MainActivity: FlutterActivity() {
  var calll =""
  var hand = Handler()
  private val CHANNEL = "rjm.status.videostatus/share"
  @TargetApi(Build.VERSION_CODES.GINGERBREAD)
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    val builder = StrictMode.VmPolicy.Builder()
    StrictMode.setVmPolicy(builder.build())
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "shareVideo") {

        shareFile(call.arguments.toString());

      } else {
        Log.e("call","nofounsd");
        result.notImplemented()
      }
    }

  }
  private fun shareFile(path:String) {
    val share = Intent(Intent.ACTION_SEND)
    val uri = Uri.fromFile(File(path))
    share.putExtra(Intent.EXTRA_STREAM, uri)
    share.type = "video/*"

    startActivity(Intent.createChooser(share, "Share video using"))

  }

}
