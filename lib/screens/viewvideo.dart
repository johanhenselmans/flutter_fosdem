import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fosdem/utils/settings_controller.dart';
import 'package:fosdem/utils/style.dart';
import 'package:go_router/go_router.dart';

import 'package:fosdem/widgets/vlc_player_with_controls.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class ViewVideo extends StatefulWidget {
  SettingsController settingscontroller;

  String videoURL = "";
  static const routeName = 'viewvideo';

  ViewVideo(
      {Key? key, required this.settingscontroller, required this.videoURL})
      : super(key: key);

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();

  //

  void _goback() async {
    await _controller!.stopRecording();
    await _controller!.stopRendererScanning();
    await _controller!.dispose();

    GoRouter.of(context).pop();
    //GoRouter.of(context).go('/');
  }

  @override
  void initState() {
    super.initState();

    //
    //
    _controller = VlcPlayerController.network(
      widget.videoURL,
      hwAcc: HwAcc.full,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
    _controller!.addOnInitListener(() async {
      await _controller!.startRendererScanning();
    });
    _controller!.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(padding: const EdgeInsets.all(24), children: [
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
                onPressed: () => _goback(),
              ),
              ]
        ),
          SizedBox(
            height: 400,
            child: VlcPlayerWithControls(
              key: _key,
              controller: _controller!,
            ),
          ),
          SimpleGestureDetector(
              onTap: () async {
                await _controller!.setMediaFromNetwork(
                  widget.videoURL,
                  hwAcc: HwAcc.full,
                );
              },
              child: Container()),
        ]),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    //await _controller!.stopRecording();
    //await _controller!.stopRendererScanning();
    //await _controller!.dispose();
  }
}
