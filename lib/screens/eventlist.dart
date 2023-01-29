import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosdem/data/database_helper.dart';
import 'package:fosdem/main.dart';

//import 'package:fosdem_access/src/app.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/style.dart';
import 'package:fosdem/utils/utils.dart';
import 'package:fosdem/widgets/fosdem_app_bar.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

/// Displays a list of Events.
class EventList extends StatefulWidget {
  final SettingsController settingsController;

  const EventList({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  static const routeName = '/eventlist';
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Event>? eventList = [];

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

  Future<List<Event>> getEventList() async {
    List<Event> eventList = await databaseHelper.getEventsFromDb(
        int.parse(widget.settingsController.fosdemCurrentYear));
    return eventList;
  }

// To work with lists that may contain a large number of items, it’s best
// to use the ListView.builder constructor.
//
// In contrast to the default ListView constructor, which requires
// building all Widgets up front, the ListView.builder constructor lazily
// builds Widgets as they’re scrolled into view.

  Widget showSearchableList(eventList) {
    return SearchableList<Event>(
      initialList: eventList,
      builder: (Event anEvent) => EventItem(event: anEvent),
      filter: (value) => eventList
          .where(
            (element) => element.title.toLowerCase().contains(value),
          )
          .toList(),
      emptyWidget: const EmptyView(),
      inputDecoration: InputDecoration(
        labelText: "Search Events",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: FutureBuilder<List<Event>>(
            future: getEventList(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
              if (snapshot.hasData) {
                eventList = snapshot.data;
                return showSearchableList(eventList!);
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

class EventItem extends StatelessWidget {
  final Event event;

  const EventItem({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow[700],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Firstname: ${event.title}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lastname: ${event.room}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Age: ${event.start}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no event is found with this title'),
      ],
    );
  }
}
