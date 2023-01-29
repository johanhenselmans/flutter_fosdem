import 'package:flutter/material.dart';
import 'package:fosdem/data/database_helper.dart';
import 'package:fosdem/screens/conferencelist.dart';
import 'package:fosdem/screens/eventlist.dart';
import 'package:fosdem/utils/constants.dart';
import 'multiple_tab.dart';
import 'single_tab.dart';
import 'package:fosdem/utils/preferences.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:fosdem/models/event.dart';
import 'package:fosdem/screens/settings_view.dart';
import 'package:fosdem/data/xml_ds.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsController settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  // set the preferences
  Preferences prefs = Preferences();
  await prefs.loadPreferences();

  DateTime now =  DateTime.now();
  int currentyear = now.year;
  await settingsController.updateCurrentYear(currentyear.toString());
//  XMLDatasource datasource = XMLDatasource();
//  await datasource.getEvents(MAINURL, currentyear.toString());
  DatabaseHelper dbhelper = DatabaseHelper();
  await dbhelper.updateEventsFromInternet(year: currentyear.toString());
  runApp(MultiProvider(providers: [
    ChangeNotifierProxyProvider<DatabaseHelper, Event>(
    create: (context) => Event(""),
    update: (context, dbhelper, event) {
      if (event == null) throw ArgumentError.notNull('event');
      return event;
    }),
    ChangeNotifierProvider(create: (context) => Event("")),
    ChangeNotifierProxyProvider<Event, DatabaseHelper>(
        create: (context) => DatabaseHelper(),
        update: (context, event, databasehelper) {
          if (databasehelper == null) throw ArgumentError.notNull('databasehelper');
          return databasehelper;
        }),
  ], child: MaterialApp(
      home: App(settingsController: settingsController),
    ),
  ),
  );
}

class App extends StatefulWidget {
  final SettingsController settingsController;
  const App({
    Key? key,
    required this.settingsController,
  }) : super(key: key);
  
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Fosdem'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Years'),
              Tab(text: 'Video'),
              Tab(text: 'Settings'),

            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            EventList(settingsController: widget.settingsController,),
            ConferenceList(settingsController: widget.settingsController,),
            SingleTab(),
            SettingsView(controller: widget.settingsController),
          ],
        ),
      ),
    );
  }
}
