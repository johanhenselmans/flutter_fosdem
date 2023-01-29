import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/style.dart';
import 'package:fosdem/utils/utils.dart';
import 'dart:io' show Platform;

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
//class SettingsView extends StatelessWidget {

class SettingsView extends StatefulWidget  with ChangeNotifier {
  SettingsController controller;

  SettingsView({Key? key, required this.controller}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String currentYear = "";
  String selectedYear = "";

  int _tapcount = 0;


  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleSettingsChanged);
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

  void _countTaps() {
    _tapcount++;
    if (_tapcount > 4) {
      _tapcount = 0;
      GoRouter.of(context).go('/debug');
    }
  }



  @override
  Widget build(BuildContext context) {
    //});
    return
        ListView(
      //padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 38),
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.sensor_door_rounded, size: 32),
        Text("Huidige Fosdem:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text("${selectedYear}", textAlign: TextAlign.center),
        //Text("server: ${widget.controller.fosdemServerIP}",
        //    textAlign: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        Text("\nLaatste Fosdem:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Wifi: ${currentYear} ", textAlign: TextAlign.center),
        ElevatedButton(
          style: fosdemElevatedButtonStyle,
          child: const Text(
            "Ga naar Laatste Fosdem",
            textAlign: TextAlign.center,
          ),
          onPressed:() => (){ bool value = true;
                if (value) {
                  GoRouter.of(context).pushReplacement('/');
                } else {
                  if (this.mounted) {
                    setState(() {});
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Kon geeen verbinding maken met deze WiFi. U bent vermoedelijk niet in de buurt."),
                  ));
                }
          },
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
        ),
        GestureDetector(
        onTap: _countTaps,
        child: FutureBuilder<PackageInfo>(
            future: getPackageInfo(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasData) {
                PackageInfo? packageInfo = snapshot.data;
                return Column(children: [
                  Text('Deze App heet: ${packageInfo!.appName}'),
                  Text(
                      'Versie:  ${packageInfo.version}, build ${packageInfo.buildNumber}'),
                ]);
              } else if (snapshot.hasError) {
                return Text('I could not find a version of the app');
              } else {
                List<Widget> children;
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              }
            }),
    )

    ],
    );
  }
}
