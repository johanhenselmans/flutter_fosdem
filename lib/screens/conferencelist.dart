import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosdem/main.dart';

//import 'package:fosdem_access/src/app.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/data/database_helper.dart';
import 'package:fosdem/utils/utils.dart';
import 'package:fosdem/widgets/fosdem_app_bar.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:fosdem/models/conference.dart';
/// Displays a list of SampleItems.
class ConferenceList extends StatelessWidget {
  ConferenceList(
      {Key? key,
      required SettingsController? this.settingsController,
      required})
      : super(key: key);

  static const routeName = '/conferencelist';
  final SettingsController? settingsController;
  final DatabaseHelper databaseHelper = DatabaseHelper();

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


Future<List<Conference>> getConferenceList() async {
  List<Conference> conferenceList = await databaseHelper.getConferencesFromDb();
  return conferenceList;
}

// To work with lists that may contain a large number of items, it’s best
// to use the ListView.builder constructor.
//
// In contrast to the default ListView constructor, which requires
// building all Widgets up front, the ListView.builder constructor lazily
// builds Widgets as they’re scrolled into view.
  List<Conference>? conferenceList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: Container(
          child: FutureBuilder<List<Conference>>(
              future: getConferenceList(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Conference>> snapshot) {
                if (snapshot.hasData) {
                  conferenceList = snapshot.data;
                  return ListView.builder(
                   itemCount: conferenceList!.length,
                    itemBuilder: (BuildContext context, int index){
                     return Container(
                       child: Center(
                         child: Text('${conferenceList![index].title}')
                       )
                     );
                    },
                  );
             } else {
                  return Column(children: <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                  ]);
                }
              }),
        ),
      );
    }
  }

