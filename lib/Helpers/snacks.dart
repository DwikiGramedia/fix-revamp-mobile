import 'package:flutter/material.dart';

class Snacks {
  static Widget message(String text) {
    return SnackBar(
      backgroundColor: Color(0xFF001F5C),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Widget error(String text) {
    return SnackBar(
      backgroundColor: Color(0xFF001F5C),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.warning,
            color: Color(0xFFCE031C),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Widget success(String text) {
    return SnackBar(
      backgroundColor: Color(0xFF4285F4),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.warning,
            color: Color(0xFF001F5C),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF001F5C)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget errorAction(
      String text,
      String actionTitle,
      VoidCallback onPressed,
      bool isInfinity,
      ) {
    return SnackBar(
      duration: isInfinity
          ? const Duration(minutes: 5)
          : const Duration(milliseconds: 4000),
      backgroundColor: Color(0xFF001F5C),
      action: SnackBarAction(
        textColor: Color(0xFF32CFBC),
        label: actionTitle,
        onPressed: onPressed,
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.warning, color: Color(0xFFCE031C)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
