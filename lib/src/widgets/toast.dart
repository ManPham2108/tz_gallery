import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

FToast? fToast;
Duration toastDuration = const Duration(seconds: 2);

class Toast extends StatelessWidget {
  final String msg;
  const Toast({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: const BoxDecoration(
            color: Color(0xFF141415),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 16,
              fontWeight: Platform.isIOS ? FontWeight.w600 : FontWeight.w500,
              color: const Color(0xFFF4F5F6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static void showToast(BuildContext context, String msg) {
    if (fToast != null) return;
    fToast = FToast();
    fToast?.init(context);
    fToast?.showToast(
      child: Toast(msg: msg),
      gravity: ToastGravity.NONE,
      toastDuration: toastDuration,
      ignorePointer: true,
    );
    Future.delayed(toastDuration, () {
      fToast = null;
    });
  }
}
