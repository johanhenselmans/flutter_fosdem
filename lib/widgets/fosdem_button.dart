import 'package:flutter/material.dart';
import 'package:fosdem/utils/style.dart';

var fosdemBorderRadius = BorderRadius.circular(8.0);

class FosdemButtonDONOTUSE_NOT_FINISHED extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? iconData;

  const FosdemButtonDONOTUSE_NOT_FINISHED(this.text, this.onPressed,
      {this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: fosdemBorderRadius,
        color: fosdemBlue,
      ),
      child: Material(
        borderRadius: fosdemBorderRadius,
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: <Widget>[
              iconData != null
                  ? LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: fosdemBlue,
                          borderRadius: fosdemBorderRadius,
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      );
                    })
                  : Container(),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // InkWell(
    //   onTap: this.onPressed,
    //   child: Container(
    //     // height: MediaQuery.of(context).size.width * .08,
    //     // width: MediaQuery.of(context).size.width * .3,
    //     decoration: BoxDecoration(
    //       borderRadius: woodyBorderRadius,
    //       // color: woodyBlue,
    //     ),
    //     child: Container(
    //       color: Colors.red,
    //       padding: EdgeInsets.all(8.0),
    //       child:
    //     ),
    //   ),
    // );
  }
}
