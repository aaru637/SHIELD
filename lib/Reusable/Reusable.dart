import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Reusable {
  static void Success(String Message, BuildContext context) {
    showToast(Message,
        textStyle: const TextStyle(
          fontSize: 14,
          wordSpacing: 0.1,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: false,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.green,
      alignment: Alignment.bottomCenter,
      position: StyledToastPosition.bottom,
      animation: StyledToastAnimation.fade,
      duration: Duration(seconds: 5),
      context: context
    );
  }

 static void Failure(String Message, BuildContext context) {
    showToast(Message,
        textStyle: const TextStyle(
            fontSize: 14,
            wordSpacing: 0.1,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        textPadding: const EdgeInsets.all(23),
        fullWidth: false,
        toastHorizontalMargin: 25,
        borderRadius: BorderRadius.circular(15),
        backgroundColor: Colors.red,
        alignment: Alignment.bottomCenter,
        position: StyledToastPosition.bottom,
        animation: StyledToastAnimation.fade,
        duration: Duration(seconds: 5),
        context: context
    );
  }
}
