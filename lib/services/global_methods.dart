import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class GlobalMethods {
  static String formattedDateText(String publishedAt) {
    final parsedData = DateTime.parse(publishedAt);
    String formattedDate = DateFormat("yyyy-mm-dd hh:mm:ss").format(parsedData);

    DateTime publishedDateTime =
        DateFormat("yyyy-mm-dd hh:mm:ss").parse(formattedDate);

    return "${publishedDateTime.day}/${publishedDateTime.month}/${publishedDateTime.year} at ${publishedDateTime.hour}:${publishedDateTime.minute}";
  }

  static Future<void> errorDialog(
      {required String errMsg, required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(errMsg),
          title: const Row(
            children: [
              Icon(
                IconlyBold.danger,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text('An error occurred')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
