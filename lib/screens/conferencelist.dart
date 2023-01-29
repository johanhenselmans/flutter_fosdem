import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosdem/main.dart';

//import 'package:fosdem_access/src/app.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/style.dart';
import 'package:fosdem/utils/utils.dart';
import 'package:fosdem/widgets/fosdem_app_bar.dart';
import 'package:searchable_listview/searchable_listview.dart';

/// Displays a list of SampleItems.
class ConferenceList extends StatelessWidget {
  ConferenceList(
      {Key? key,
      required SettingsController? this.settingsController,
      required})
      : super(key: key);

  static const routeName = '/conferencelist';
  final SettingsController? settingsController;

  void _displayAlert(String aText, BuildContext context) {
    var alert = AlertDialog(
      title: Text("Error"),
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

// To work with lists that may contain a large number of items, it’s best
// to use the ListView.builder constructor.
//
// In contrast to the default ListView constructor, which requires
// building all Widgets up front, the ListView.builder constructor lazily
// builds Widgets as they’re scrolled into view.

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Container(),
    );
  }
}
