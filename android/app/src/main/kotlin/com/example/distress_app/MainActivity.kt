package com.example.distress_app
import android.telephony.SmsManager;
import android.util.Log;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.os.Bundle
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull

class MainActivity : FlutterActivity() {
    private val callResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method.equals("send")) {
                            val num: String = call.argument("phone")?:""
                            val msg: String = call.argument("msg")?:""
                            sendSMS(num, msg, result)
                        } else {
                            result.notImplemented()
                        }
    }
  }

    private fun sendSMS(phoneNo: String, msg: String, result: MethodChannel.Result) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }

    companion object {
        private const val CHANNEL = "sendSms"
    }
}