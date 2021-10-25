import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogs {
  final BuildContext context;

  CustomDialogs(this.context);

  Future<dynamic> showAlertDialog({
    title,
    message,
    positiveButtonText,
    negativeButtonText = '',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(title),
          scrollable: true,
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: <Widget>[
            if (negativeButtonText != '')
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  negativeButtonText,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                positiveButtonText,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showTimerAlertDialog({
    title,
    message,
    positiveButtonText = "Dismiss",
  }) {
    late Timer _timer;
    int start = 15;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (
        BuildContext context,
      ) {
        return StatefulBuilder(
          builder: (context, setState) {
            const oneSec = const Duration(seconds: 1);
            _timer = new Timer.periodic(
              oneSec,
              (Timer timer) {
                _timer.cancel();
                if (start == 0) {
                  timer.cancel();
                  Navigator.of(context).pop(true);
                } else {
                  setState(() {
                    start--;
                  });
                }
              },
            );

            return AlertDialog(
              title: Text(title),
              scrollable: true,
              content: Text(
                message,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _timer.cancel();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "$positiveButtonText (${start}s)",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> showLoadingDialog({message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 25,
              ),
              Text('$message')
            ],
          ),
        );
      },
    );
  }
}
