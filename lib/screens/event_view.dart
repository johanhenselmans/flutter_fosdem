import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fosdem/data/database_helper.dart';
import 'package:fosdem/models/event.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/style.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
//class SettingsView extends StatelessWidget {

class EventView extends StatefulWidget with ChangeNotifier {
  SettingsController controller;
  Event event;

  EventView({Key? key, required this.controller, required this.event})
      : super(key: key);
  static const routeName = 'eventview';

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  String currentYear = "";
  String selectedYear = "";
  bool enabled = true;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<bool> _selections = [false, false];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleSettingsChanged);
    selectedYear = widget.controller.fosdemSelectedYear;
    if(widget.event.favorite == 1){
      _selections[1]=true;
      _selections[0]=false;
    } else {
      _selections[1]=false;
      _selections[0]=true;

    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleSettingsChanged);
    //widget.controller.removeListener(_handleFosdemChanged);
    super.dispose();
  }

  void _handleSettingsChanged() {
    if (widget.controller.fosdemCurrentYear != "") {
      currentYear = widget.controller.fosdemCurrentYear;
      selectedYear = widget.controller.fosdemSelectedYear;
      setState(() {});
    }
  }

/*
  void _handleFosdemChanged() {
    ServerAddress? anAddress;
    anAddress = fosdemServers.getCurrentFosdem();
    //fosdemServers.getCurrentFosdem().then((value) => anAddress = value);
    if (!anAddress.serverIP!.isEmpty) {
      if (this.mounted) {
        setState(() {
          serverName = anAddress?.serverName;
          serverIP = anAddress?.serverIP;
        });
      }
    }
  }
*/
  Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  void _gohome() {
    GoRouter.of(context).pop();
    //GoRouter.of(context).go('/');
  }

  List getLinkList() {
    final List linklist = widget.event.links;
    return linklist;
  }

  Widget getVideo() {
    final List linklist = widget.event.links;
    for (Map item in linklist) {
      if (item['href'].toString().contains('video.fosdem')) {}
    }
    return Container();
  }

  List getPersonList() {
    final List personlist = widget.event.persons;
    return personlist;
  }

  List getAttachmentList() {
    final List attachmentlist = widget.event.attachments;
    return attachmentlist;
  }

  Future<void> _launchUrl(String anUrl) async {
    if (anUrl.contains('video')) {
      widget.controller.updateSelectedVideo(anUrl);
      GoRouter.of(context).push('/viewvideo');
      // GoRouter.of(context).go('/viewvideo');
    } else {
      if (!await launchUrl(Uri.parse(anUrl))) {
        throw Exception('Could not launch $anUrl');
      }
    }
  }

/*
  void onPressed(){
    if (enabled = false){
      enabled = true;
    } else {
      enabled = false;
    }
    setState(() {
      enabled;
    });
  }
*/
  Widget checkHTMLContent(String? content) {
    if (content != null) {
      var cleancontent = content.replaceAll('\\\\n', '<br/>');
      return Html(data: cleancontent);
    } else {
      return Container();
    }
  }


  @override
  Widget build(BuildContext context) {
//    final VoidCallback? onPressed = enabled ? () {} : null;
//    final ColorScheme colors = Theme.of(context).colorScheme;
    //});
    return SafeArea(
      child: Scaffold(
        body: SimpleGestureDetector(
          //onTap: () {
          //  _gohome();
          //},
          onHorizontalSwipe: (SwipeDirection direction) {
            if (direction == SwipeDirection.right) {
              _gohome();
            }
          },
          swipeConfig: const SimpleSwipeConfig(
            verticalThreshold: 40.0,
            horizontalThreshold: 40.0,
            swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
          ),
          child: ListView(
            //padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 38),
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                  ElevatedButton(
                    style: fosdemElevatedButtonStyle,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_outlined),
                        const Text(
                          "Back",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    onPressed: () => _gohome(),
                  ),
                  Center(child: ToggleButtons(
                      onPressed: (int index) {
                        widget.event.favorite = index;
                        databaseHelper.updateEvent(widget.event);
                        setState(() {
                          // The button that is tapped is set to true, and the others to false.
                          for (int i = 0; i < _selections.length; i++) {
                            _selections[i] = i == index;
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: fosdemBlue,
                      selectedColor: Colors.white,
                      fillColor: fosdemBlue,
                      color: fosdemBlue,
                      isSelected: _selections,
                      children: <Widget>[
                        const Icon(Icons.thumbs_up_down),
                        const Icon(Icons.thumb_up),
                      ]),
                  ),
                ]),


              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children:[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text("${widget.event.eventdate} ${widget.event.start}",
                              textAlign: TextAlign.center),
                          Text("${widget.event.room}", textAlign: TextAlign.center),]),
                    ]),

              const SizedBox(
                height: 20,
              ),
              Text(widget.event.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${widget.event.track}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.event.subtitle ?? '', textAlign: TextAlign.center),
//Text("${widget.event.persons} ", textAlign: TextAlign.center),


              ListView.builder(
                  itemCount: getPersonList().length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = getPersonList()[index];
                    return Column(children: [
                      Text("${item['\$t']}"),
                    ]);
                  }),
              checkHTMLContent(widget.event.description),

              //Text("${widget.event.links}", textAlign: TextAlign.center),
              ListView.builder(
                  itemCount: getLinkList().length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = getLinkList()[index];
                    return Column(children: [
                      ElevatedButton(
                        onPressed: () {
                          _launchUrl(item['href']);
                        },
                        style: fosdemElevatedButtonStyle,
                        child: Text("${item['\$t']}"),
                      )
                      //Text("${item['href']}"),
                      //Text("${item['\$t']}"),
                    ]);
                  }),
              //Text("${widget.event.attachments} ", textAlign: TextAlign.center),
              ListView.builder(
                  itemCount: getAttachmentList().length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = getLinkList()[index];
                    return Column(children: [
                      ElevatedButton(
                        style: fosdemElevatedButtonStyle,
                        onPressed: () {
                          _launchUrl(item['href']);
                        },
                        child: Text("${item['\$t']} (${item['type']})"),
                      ),
                      //Text("${item['type']}"),
                      //Text("${item['href']}"),
                      //Text("${item['\$t']}"),
                    ]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
