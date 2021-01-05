import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget text(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      text,
      style: TextStyle(fontSize: 21),
    ),
  );
}

Widget richText({
  String text1, text2
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: RichText(
      text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: text1, style: TextStyle(fontSize: 21, color: Colors.black)),
            TextSpan(text: text2, style: TextStyle(fontSize: 21, color: Colors.black)),
          ]
      ),
    ),
  );
}

Future<void> showDialogAnnounce({
  @required String content,
  Function onCancel
}) async {
  Get.defaultDialog(
    title: 'Announce',
    middleText: content,
    textCancel: 'ok',
    cancelTextColor: Colors.red,
    buttonColor: Colors.green,
    onCancel: onCancel
  );
}

Future<void> showDialogChoose({
  @required String content,
  Function onConfirm,
  String textCancel,
  String textConfirm
}) async {
  Get.defaultDialog(
    title: 'Announce',
    middleText: content,
    textCancel: textCancel,
    cancelTextColor: Colors.red,
    textConfirm: textConfirm,
    confirmTextColor: Colors.green,
    buttonColor: Colors.yellow,
    onConfirm: onConfirm,
  );
}
