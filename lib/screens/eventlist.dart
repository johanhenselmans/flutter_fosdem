import 'package:flutter/material.dart';
import 'package:fosdem/data/database_helper.dart';

import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/widgets/empty_view.dart';
import 'package:fosdem/widgets/event_item.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:fosdem/models/event.dart';

/// Displays a list of Events.
class EventList extends StatefulWidget with ChangeNotifier {
  final SettingsController settingsController;

  EventList({
    Key? key,
    required this.settingsController,
  }) : super(key: key);
  static const routeName = '/eventlist';

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Event>? eventList = [];

  @override
  void initState() {
    super.initState();
    widget.settingsController.addListener(_handleSettingsChanged);
  }


  @override
  void dispose() {
    widget.settingsController.removeListener(_handleSettingsChanged);
    //widget.controller.removeListener(_handleFosdemChanged);
    super.dispose();
  }

  void _handleSettingsChanged() {
    if (widget.settingsController.fosdemCurrentYear != "") {
    }
    setState(() {});
  }


  void _displayAlert(String aText, BuildContext context) {
    var alert = AlertDialog(
      title: const Text("Error"),
      content: Text(aText),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
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
    List<Event> eventList = [];
    if(widget.settingsController.SelectedTrack != ""){
      eventList = await databaseHelper.getEventsFromDb(
          int.parse(widget.settingsController.fosdemSelectedYear), track: widget.settingsController.SelectedTrack );
    } else {
      eventList = await databaseHelper.getEventsFromDb(
          int.parse(widget.settingsController.fosdemSelectedYear), track: "");
    }
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

      //initialList: eventList,
      builder: (Event anEvent) => EventItem(settingsController: widget.settingsController, event: anEvent),
      loadingWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text('Loading events...')
        ],
      ),asyncListCallback: () async {
        await Future.delayed(
          const Duration(
            milliseconds: 500,
          ),
        );
        return eventList;
      },asyncListFilter: (q, aList) {
        return aList
            .where((element) => element.title.contains(q))
            .toList();
      },
//      filter: (value) => eventList
//          .swhere(
//            (element) => element.title.toLowerCase().contains(value),
//          )
//          .toList(),
      onItemSelected: (Event item) {},
      emptyWidget: const EmptyView(),

      inputDecoration: InputDecoration(
        labelText: "Search Events",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          //borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Event>>(
          future: getEventList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasData) {
              eventList = snapshot.data;
              return showSearchableList(eventList!);
            } else {
              return Column(children: const <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ]);
            }
          }),
    );
  }
}

