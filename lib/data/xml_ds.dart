import 'dart:async';
import 'dart:convert';
import 'package:fosdem/utils/network_util.dart';
import 'package:fosdem/models/conference.dart';
import 'package:fosdem/models/event.dart';
import 'package:fosdem/utils/constants.dart';

class XMLDatasource {
  NetworkUtil _netUtil = NetworkUtil();

  Future<Conference> getConference(int year) {
    DateTime now =  DateTime.now();
    int currentYear = now.year;
    Conference aConference = Conference("", "", "");

    String mainURL = MAINURL;
    if (year <  currentYear){
      mainURL = ARCHIVEURL;
    }
    return _netUtil.getXML(mainURL + year.toString() +GETEVENTURL).then((dynamic res) {
      List<Conference> conferenceList = [];
      if (res != null) {
        Map<String, dynamic> response = jsonDecode(res);
        if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
          print("getConferences xmlres:");
          print(res.toString());
          print("jsonresponse:");
          print(response.toString());
        }
        if (response["error"] != null) throw Exception(response["error_msg"]);

          aConference = Conference.fromMapToObject(response['schedule']['conference']);
          if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
            //print("RuntimeEventcatecory:"+conference.runtimeType.toString());
            print("Conference ${aConference.title}");
            print("Start: ${aConference.start}");
            print("End RuntimeType: ${aConference.end.runtimeType.toString()}");
            print(
                "days: ${aConference.days.toString()} Type: ${aConference.days.runtimeType.toString()}");
          }
          conferenceList.add(aConference);
      }
      return aConference;
    });
  }

  Future<List<Event>> getEvents(String mainURL, String year,
      {String? eventcode}) {
    return _netUtil
        .getXMLHeavy(mainURL + year + GETEVENTURL)
        .then((dynamic res) {
      var tmpEventList = [];
      if (res != null) {
        Map<String, dynamic> response = jsonDecode(res);
        if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
          print("getEvents xmlres:");
          print(res.toString());
          print("jsonresponse:");
          print(response.toString());
        }
        var tmpMapList = response['schedule'];
        for (var entry in tmpMapList.entries) {
          if (entry.key == "conference"){

          }
          if (entry.key == "day") {
            List dayList = entry.value;
            if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
              // if there is only one event, a hashmap is returned,
              // otherwise a list of hashmaps.
              // _InternalLinkedHashMap<String, dynamic>
              // List<dynamic>
              print("Type day list: " + dayList.runtimeType.toString());
            }
            if (dayList.runtimeType.toString().contains("List<dynamic>")) {
              for (var listEntry in dayList) {
                if (debug == DebugLevel.All ||
                    debug == DebugLevel.XMLJSONParsing) {
                  print("Type listEntry: " + listEntry.runtimeType.toString());
                }
                for (var entry in listEntry.entries) {
                  if (debug == DebugLevel.All ||
                      debug == DebugLevel.XMLJSONParsing) {
                    print("Type entry: " + listEntry.runtimeType.toString());
                  }
                  if (entry.key == "room") {
                    var roomList = entry.value;
                    for (var listEntry in roomList) {
                      for (var mapEntry in listEntry.entries) {
                        if (mapEntry.key == "name") {
                          print('room: ' + mapEntry.value);
                        }
                        if (mapEntry.key == "event") {
                          var eventsList = mapEntry.value;
                          if (eventsList.runtimeType
                              .toString()
                              .contains("List<dynamic>")) {
                            for (var eventsMap in eventsList) {
                              //      var eventsMap = entry[0].value;
//                      for (var eventMap in eventsMap.entries){
                              if (debug == DebugLevel.All ||
                                  debug == DebugLevel.XMLJSONParsing) {
                                print("value event map: " +
                                    eventsMap.runtimeType.toString());
                              }
                              Map anEventMap = returnAProperEventMap(eventsMap);
                              tmpEventList.add(anEventMap);
                            }
                          } else {
                            Map anEventMap = returnAProperEventMap(eventsList);
                            tmpEventList.add(anEventMap);
                          }
                          //                     }
                        }
                      }
                    }
                  }
                }
              }
            }
            if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
              print("End of day list: ");
            }
          }
          // there is only one map, not a list.
        }
      }

      List<Event> eventList =
          tmpEventList.map((value) => Event.fromMapToObject(value)).toList();
      return eventList;
    });
  }

  Map returnAProperEventMap(Map eventmap) {
    // we create an links list so that they can be stored as a json object in
    // the database: we find if there are any pages, if not, it will be ant empty list.
    // object stuff.
    List<String?> linkList = [];
    List<String?> personList = [];
    if (eventmap['links']['link'] != null) {
      if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
        //print("We have links");
        print("links: " +
            eventmap['links'].toString() +
            " runtimetype: links" +
            eventmap['links'].runtimeType.toString() +
            " runtimetype: links " +
            eventmap['links']['link'].runtimeType.toString());
      }
      //Map<String, dynamic> thelinks = eventmap['links'];
      if (eventmap['links']['link']
          .runtimeType
          .toString()
          .contains("List<dynamic>")) {
        List<dynamic> data = eventmap['links']['link'];
        data.forEach((mapvalue) {
          linkList.add(mapvalue['\$t']);
        });
      } else {
        //There is only one value, which results in a map instead of a list.
        Map mapvalue = eventmap['links']['link'];
        linkList.add(mapvalue['\$t']);
      }
      //List<dynamic> theaudiopages = eventmap['Audio']['Page'];
      //theaudiopages.forEach((mapvalue) {
      //  audiopagesList.add(mapvalue['\$t']);
      //});
    }
    eventmap['Links'] = linkList;
    return eventmap;
  }

  /*

   */

  Future<List<Event>> getEventPerYear(String mainURL, String year) {
    return _netUtil
        .getXMLHeavy(mainURL + year + GETEVENTURL)
        .then((dynamic res) {
      var tmpEventList = [];
      if (res != null) {
        Map<String, dynamic> response = jsonDecode(res);
        if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
          print("geteventsperGroup res:");
          print(res.toString());
          print("jsonresponse:");
          print(response.toString());
        }
        var tmpMapList = response['day'];
        for (var entry in tmpMapList.entries) {
          if (entry.key == "room") {
            var eventmaps = entry.value;
            if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
              // if there is only one event, a hashmap is returned,
              // otherwise a list of hashmaps.
              // _InternalLinkedHashMap<String, dynamic>
              // List<dynamic>
              print("value event map: " + eventmaps.runtimeType.toString());
            }
            if (eventmaps.runtimeType.toString().contains("List<dynamic>")) {
              for (Map eventmap in eventmaps) {
                Map anEventMap = returnAProperEventMap(eventmap);
                tmpEventList.add(anEventMap);
              }
              // there is only one map, not a list.
            } else {
              Map anEventMap = returnAProperEventMap(eventmaps);
              tmpEventList.add(anEventMap);
            }
          }
        }
      }

      List<Event> eventList =
          tmpEventList.map((value) => Event.fromMapToObject(value)).toList();
      return eventList;
    });
  }

/*
 this is a strange one: it actually returns all the events that are available in the group that the eventcode
 is a part of. Better not to  use.
 */
  Future<List<Event>> getEventsPerEventCode(String mainURL, String year) {
    return _netUtil
        .getXMLHeavy(mainURL + year + GETEVENTURL)
        .then((dynamic res) {
      var tmpEventList = [];
      if (res != null) {
        Map<String, dynamic> response = jsonDecode(res);
        if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
          print("getevents res:");
          print(res.toString());
          print("jsonresponse:");
          print(response.toString());
        }
        var tmpMapList = response['Events'];
        //Map mymap = tmpList['Event'];
        for (var entry in tmpMapList.entries) {
          if (entry.key == "Event") {
            var eventmaps = entry.value;
            if (debug == DebugLevel.All || debug == DebugLevel.XMLJSONParsing) {
              // if there is only one event, a hashmap is returned,
              // otherwise a list of hashmaps.
              // _InternalLinkedHashMap<String, dynamic>
              // List<dynamic>
              print("value event map: " + eventmaps.runtimeType.toString());
            }
            if (eventmaps.runtimeType.toString().contains("List<dynamic>")) {
              for (Map eventmap in eventmaps) {
                Map aEventMap = returnAProperEventMap(eventmap);
                tmpEventList.add(aEventMap);
              }
              // there is only one map, not a list.
            } else {
              Map aEventMap = returnAProperEventMap(eventmaps);
              tmpEventList.add(aEventMap);
            }
          }
        }
      }

      List<Event> eventList =
          tmpEventList.map((value) => Event.fromMapToObject(value)).toList();
      return eventList;
    });
  }
}
