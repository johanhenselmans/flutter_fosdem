import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:fosdem/models/conference.dart';
import 'package:fosdem/models/event.dart';
import 'package:fosdem/utils/constants.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fosdem/data/xml_ds.dart';

// inspired by https://github.com/udara94/flutterTodo
// and https://flutter.dev/docs/cookEvent/persistence/sqlite
// https://medium.com/swlh/flutter-get-data-from-a-rest-api-and-save-locally-in-a-sqlite-database-9a9de5867939
// https://github.com/fabiojansenbr/flutter_api_to_sqlite

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async => _db ??= await initDb();

  DatabaseHelper.internal();

  void updateDatabaseHelper() {
    notifyListeners();
  }


  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "fosdem.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }
  // here the upgrades since the last version are added.
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    //await db.execute("ALTER TABLE Conference add column eventdownloaded INTEGER");
    //await db.execute("ALTER TABLE Event add column description TEXT");
    //await db.execute("ALTER TABLE Event add column eventdate TEXT");
    //await db.execute("ALTER TABLE Event add column favorite INTEGER");
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Conference(id INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER, title TEXT,  subtitle TEXT, venue TEXT, city TEXT, start TEXT, end TEXT, days INTEGER, daychange TEXT, timeslotduration TEXT, eventdownloaded INTEGER)");
    await db.execute(
        "CREATE TABLE Event(id INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER, eventid INTEGER, start TEXT, duration TEXT, room TEXT, slug TEXT, title TEXT, subtitle TEXT, track TEXT, type TEXT, language TEXT,  abstract TEXT, description TEXT, eventdate TEXT, links TEXT, persons TEXT, attachments TEXT, favorite INTEGER)");
    //await db.execute("CREATE UNIQUE INDEX Idx_Event on Event(eventid, year)");
    if (debug == DebugLevel.All || debug == DebugLevel.Database) {
      print("Created tables");
    }
  }


  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }



  Future<int?> insertConference(Conference aConference) async {
    var dbClient = await db;
    int? res;
    await dbClient.transaction((txn) async {
      try {
        res = await txn.insert("Conference", aConference.toMap());
      } on DatabaseException catch (e) {
        if (e.toString().contains('code 2067')) {
          print('Year unique constraint, carry on');
        }
      } catch (e) {
        print('error inserting Conference: $aConference');
        _handleError(e);
      }
    });
    return res;
  }


  Future<void> updateConference(Conference aConference) async {
    // Get a reference to the database.
    final dbClient = await db;
    await dbClient.transaction((txn) async {
      try {
        txn.update(
          'Conference',
          aConference.toMap(),
          // Ensure that the Dog has a matching id.
          where: "year = ?",
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [aConference.year],
        );
      } catch(e){
        print('error updating conference: $aConference');
        _handleError(e);
      }
    });
  }

  Future<Conference?> getConference(int? year) async {
    // Get a reference to the database.
    final dbClient = await db;
    // Update the given Dog.
    List<Map> mapConference = await dbClient.query('Conference', where: "year = ?", whereArgs: [year]);
    if (mapConference.length == 1) {
      Conference aConference = Conference.fromMapToObject(mapConference[0]);
      if (debug == DebugLevel.All || debug == DebugLevel.Database) {
        print("in getConference downloaded: ${aConference.title}");
        print("Year: ${aConference.title}");
      }
      return aConference;
    } else {
      return null;
    }
  }


  Future<int> deleteConferences() async {
    var dbClient = await db;
    int res = await dbClient.delete("Conference");
    return res;
  }
  //ToDo make sure one gets the conferences
  Future<List<Conference>>? getConferences(int year) {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Conference> tmpConferenceList = [];
//    return databaseHelper.getCategoriesFromDb().then((value) {
    databaseHelper.getConferencesFromDb().then((value) {
      tmpConferenceList = value;
      if (tmpConferenceList.isEmpty) {
        XMLDatasource xmldatasrc = XMLDatasource();
        xmldatasrc.getEvents(year.toString());
      }
      return tmpConferenceList;
    });
    return null;
  }

  Future<int?> insertEvent(Event anEvent) async {
    var dbClient = await db;
    int? res;
    await dbClient.transaction((txn) async {
      try {
        res = await txn.insert("Event", anEvent.toMap());
      } on DatabaseException catch (e) {
        if (e.toString().contains('code 2067')) {
          print('Event unique constraint, carry on');
        }
      } catch(e){
        print('error inserting Event: $anEvent');
        _handleError(e);
      }
    });
    /*
    int res = await dbClient.insert("Event", Event.toMap());
   */
    return res;
  }

  Future<int> deleteAllEvents() async {
    var dbClient = await db;
    int res = await dbClient.delete("Event");
    return res;
  }

  Future<int> deleteAllEventsExceptGroup10() async {
    var dbClient = await db;
    int res = await dbClient.delete("Event", where: "GroupCol != 10");
    return res;
  }

  Future<List<Event>> getEventsPerYear(int year) async {
    // Get a reference to the database.
    final dbClient = await db;
    // Update the given Dog.
    List<Event> foundEvents = [];
    List<Map> mapEvent = await dbClient.query('Event', where: "year = ?", whereArgs: [year]);
    mapEvent.forEach((aEventMap) {
      Event aEvent = Event.fromMapToObject(aEventMap);
      if (debug == DebugLevel.All || debug == DebugLevel.Database) {
        print("in GetEvent downloaded: ${aEvent.event_id}");
        print("Event: ${aEvent.title}");
      }
      foundEvents.add(aEvent);
    });
    return foundEvents;
  }

  Future<List<String>> getPersonsFromEvent(Event anEvent) async {
    final dbClient = await db;
    List<String> personNameList = [];
    List<Map<String, Object?>> persons = await dbClient.rawQuery(
  '''select json_extract(person.value, \'\$.\$t\') 
  from (select value from json_each(Event.persons ), 
  Event where eventid = ?) person''',
  [anEvent.event_id]);
    persons.forEach((person){
      personNameList.add(person.values.toString());
    });
    return personNameList;
  }

  Future<Event?> getEvent(Event event) async {
    // Get a reference to the database.
    final dbClient = await db;
    // Update the given Event.
    List<Map> mapEvent = await dbClient.query('Event', where: "eventid = ?", whereArgs: [event.event_id]);
    if (mapEvent.length == 1) {
      Event anEvent = Event.fromMapToObject(mapEvent[0]);
      if (debug == DebugLevel.All || debug == DebugLevel.Database) {
        print("in GetEvent downloaded: ${anEvent.event_id}");
        print("Event: ${anEvent.title}");
      }
      return anEvent;
    } else {
      return null;
    }
  }

  Future<void> updateEvent(Event anEvent) async {
    // Get a reference to the database.
    final dbClient = await db;
    // Update the given Event.
    await dbClient.transaction((txn) async {
      try {
        await txn.update('Event', anEvent.toMap(),
            // Ensure that the Event has a matching id.
            where: "eventid = ?",
            // Pass the Event's id as a whereArg to prevent SQL injection.
            whereArgs: [anEvent.event_id]);
      } on DatabaseException catch (e) {
        print('error updating Event: $anEvent');
        _handleError(e);
      } catch(e){
        print('error updating Event: $anEvent');
        _handleError(e);

      }
    });
      Conference? conference = await getConference(anEvent.year);
      // update the Year to indicate a Event is downloaded, only necessary if the Year does not already have this indication
      if (conference!.eventsdownloaded != null && conference.eventsdownloaded!= 1 ) {
        conference.eventsdownloaded = 1;
        await updateConference(conference);
      }
  }


  Future<void> putTheEventListIntoTheDatabase({List<Event>? events, int? year}) async {
    //Find the same Event in the database:
    //If it is not available, insert the Event
    final dbClient = await db;
    if (events != null && events.isNotEmpty) {
      List<String?> EventIdvalues = [];
      for (Event anEvent in events) {
        try {
          //first we check if a group variable is added: that means that this is a generic call to fetch Events
          //else we have the list of Events that are added for the logged in user.
          //If the Events are picked up while the user is logged in, the meaning of available == 0
          //means he is overEvented. Every value above means he is available.
          //If the user is not logged in, every value > 1 (1= available, 0=unavailable), means not available
          var dbList = await dbClient.query('Event', where: 'eventid = ?', whereArgs: [anEvent.event_id]);
          if (dbList.isNotEmpty) {
            Map map = dbList[0];
            // only update Event when there is a new revision or if there is no revision of the current Event
            // or if the avalable status has been changed
            Event tmpEvent = Event.fromMapToObject(map);
            // transfer data that can not be available in the downloaded Eventinfo;
              await updateEvent(tmpEvent);
          } else {
            await insertEvent(anEvent);
          }
          EventIdvalues.add(anEvent.event_id.toString());
        } on Exception catch (exception) {
          // only executed if error is of type Exception
          print(exception);
        } catch (error) {
          print(error.toString());
        }
      }
      //remove Events that are not in the internet database anymore, and the files belonging to it
      String EventIdSinqleQuoteString = EventIdvalues.fold('', (value, element) => value + ',\'' + element! + '\'');
      //print('values: ${Eventcodevalues.toString()}, string: ${EventcodeSinqleQuoteString.substring(1)}');
      //TODO remove files belonging to Eventcodes that are not there any more
      // only do this if the if the group was mentioned, otherwise it means that the Events of a logged in user
      // are picked up. That is not the complete assortiment of Events.
      if (year != null) {
        // first select the Events that are not there any more
        // then delete their assets locally: thumbnail images and audio and image files
        // the delete  the Events from the database.
        int res = await dbClient.delete(
          'Event',
          where: 'eventid not in (${EventIdSinqleQuoteString.substring(1)}) and year = ?',
          whereArgs: [year],
        );
//        int res = await dbClient.delete('Event', where: 'Eventcode not in (${Eventcodevalues.join(',')}) and groupcol = ?', whereArgs: [group],);
//        int res = await dbClient.delete('Event', where: 'Eventcode not in (?) and groupcol = ?', whereArgs: [EventcodeString.substring(1),group],);
        if (debug == DebugLevel.All || debug == DebugLevel.Database) {
          print('Events deleted: $res');
        }
      }
      //TODO: make sure the update of the database is recorded in the prefs, so we can update when the app has not updated for a day.
      //notifyListeners();
    }
  }

  Future<void> updateEventsFromInternet({required String year}) async {
    XMLDatasource xmldatasrc = XMLDatasource();
    //Get a list of Event, depending on the argument;
        ConferenceAndEvent confandevents =
        await xmldatasrc.getEvents(year);
    if (debug == DebugLevel.All || debug == DebugLevel.Database) {
      print("Got Events from Internet");
    }
        await putTheEventListIntoTheDatabase(events: confandevents.eventList);
    }

  Future<List<Event>> getEventsFromDb(int year) async {
    final dbClient = await db;
    List<Map> mapEvent = await dbClient.query('Event', where: 'year = ?', whereArgs: [year]);
    List<Event> listEvent = [];
    for (var map in mapEvent) {
      Event aEvent = Event.fromMapToObject(map);
      if (debug == DebugLevel.All || debug == DebugLevel.Database) {
        print("getEventsFromDb: ${aEvent.title}");
        print("Event title: ${aEvent.title}");
      }
      aEvent.year = year;
      listEvent.add(aEvent);
    }
    return listEvent;
  }

  Future<List<Event>> getEventList(int year ) {
    DatabaseHelper databaseHelper = DatabaseHelper();
    databaseHelper.updateEventsFromInternet(year: year.toString());
    List<Event> tmpEventList = [];
    return databaseHelper.getEventsFromDb(year).then((value) {
      tmpEventList = value;
/*  //TODO make a temporary set of Events
      if (tmpEventList == null || tmpYearList.length == 0) {
        tmpEventList.add(Year("Gratis", 1, "groep_gratis.png", 1));
        for (int i = 1; i < 9; i++) {
          tmpEventList.add(Year(
            "Groep " + i.toString(),
            i + 1,
            "groep_" + i.toString() + ".png",
            i + 1,
          ));
        }
    }
 */
      return tmpEventList;
    });
  }

  Future<List<Conference>> getConferencesFromDb() async {
    //final dbClient = await (db as FutureOr<Database>);
    final dbClient = await db;
    List<Map> mapConference = await dbClient.query('Conference');
    List<Conference> listconf = [];
    if(mapConference.isEmpty){
      for (var year in getYearList()) {
        updateEventsFromInternet(year: year.toString());
      }
      mapConference = await dbClient.query('Conference');
    }
    for (var map in mapConference) {
      Conference conf = Conference.fromMapToObject(map);
      if (debug == DebugLevel.All || debug == DebugLevel.Database) {
        print('getConferenceFromDb: ' + conf.title!);
      }
      listconf.add(conf);
    }
    return listconf;
  }
  //The yearlist is only suited for picking up some of the stuff.
  //2007 until 2011 were not delivered in xml format, and have been grazed and converted
  //by hand, sort of.
  List<int> getYearList() {
    int beginYear = 2007;
    DateTime now = DateTime.now();
    int currentYear = now.year;
    List<int> yearList = [];
    for (int i = beginYear; i <= currentYear; i++) {
      yearList.add(i);
    }
    return yearList;
  }

  //reset the Eventavailable setting for years, in case of a logout;
  Future<void> resetAvailability() async {
    List<Conference> theconferences = await getConferencesFromDb();
    theconferences.forEach((aConference){
      updateConference(aConference);
    });

  }

  Future resetData() async {
    // we do not remove the free Events from group FREEGROUP (10)
    // so we find which tasks do contain downloads from group FREEGROUP (10)
    // in the url of the task there is the Eventcode of the download.
    // so we do not delete these tasks
    DatabaseHelper dbhelper = DatabaseHelper();
    //await dbhelper.deleteAllEventsExceptGroup10();
     for (int year in getYearList()){
      await dbhelper.updateEventsFromInternet(year: year.toString());
    }
    List<Conference> conferenceList = await dbhelper.getConferencesFromDb();
    conferenceList.forEach((aConference) async {
      await dbhelper.updateEventsFromInternet(year: aConference.year.toString());
    });
  }
}
