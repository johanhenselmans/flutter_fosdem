import 'package:flutter/material.dart';
import 'package:fosdem/utils/style.dart';
import 'dart:ui' as ui;

import 'package:fosdem/widgets/fosdem_back_button.dart';

class fosdemAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  List<Widget>? actions;
  final bool canGoBack;

  fosdemAppBar(
    this.title, {
    List<Widget>? actions,
    Key? key,
    this.canGoBack = false,
  }) : super(key: key);

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

  @override
  _fosdemAppBarState createState() => _fosdemAppBarState();
}

class _fosdemAppBarState extends State<fosdemAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          height: widget.preferredSize.height,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.canGoBack ? const FosdemBackButton() : Container()
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                        decoration: BoxDecoration(
                          color: fosdemBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: fosdemWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
