import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shield/Reusable/Reusable.dart';

class SMS {
  static Future<void> SendSMS(String Message, String recepients, BuildContext context) async {
    try {
      var result = await BackgroundSms.sendMessage(
          phoneNumber: recepients, message: Message);
      Reusable.Success("Message Sent Successfully", context);
    } catch (e) {
      Reusable.Failure("Error Occured on Sending SMS.", context);
    }
  }
}
