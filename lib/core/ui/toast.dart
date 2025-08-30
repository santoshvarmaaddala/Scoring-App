import "package:fluttertoast/fluttertoast.dart";
import "package:flutter/material.dart";

void showToast(String message) {
  Fluttertoast.showToast(msg: message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.white24,
  textColor: Colors.black,
  fontSize: 16.0);
}