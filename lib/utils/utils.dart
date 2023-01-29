import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fosdem/data/database_helper.dart';


void displayAlert(String aTitle, String aText, BuildContext context) {
  var alert = AlertDialog(
    title: Text(aTitle),
    content: Text(aText),
    actions: <Widget>[
      TextButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}



class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ServerAddress {
  String? serverName;
  String? serverIP;
  //ServerAddress()

  ServerAddress({required this.serverName, required this.serverIP});

  String? ServerName() {
    return serverName;
  }

  String? ServerIP() {
    return serverIP;
  }
}


String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
