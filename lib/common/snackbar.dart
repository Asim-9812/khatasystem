import 'package:flutter/material.dart';

import 'colors.dart';

class SnackbarUtil {
  static SnackBar showSuccessSnackbar({
    required String message,
    required Duration duration,
  }) {
    return SnackBar(
      content: Center(
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 22,),
              const SizedBox(width: 10,),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ),
      backgroundColor: ColorManager.primary,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      animation: CurvedAnimation(parent: kAlwaysCompleteAnimation, curve: Curves.easeOut),
    );
  }

  static SnackBar showFailureSnackbar({
    required String message,
    required Duration duration,
  }) {
    return SnackBar(
      content: Center(
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 22,),
              const SizedBox(width: 10,),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
      ),
      backgroundColor: ColorManager.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(40, 0, 40, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      dismissDirection: DismissDirection.horizontal,
      animation: CurvedAnimation(parent: kAlwaysCompleteAnimation, curve: Curves.easeOut),
      duration: duration,
    );
  }


  static SnackBar showWarningSnackbar({
    required String message,
  }) {
    return SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: ColorManager.black.withOpacity(0.7),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      duration: const Duration(milliseconds: 400),
      dismissDirection: DismissDirection.horizontal,
      animation: CurvedAnimation(parent: kAlwaysCompleteAnimation, curve: Curves.easeOut),
    );
  }


}