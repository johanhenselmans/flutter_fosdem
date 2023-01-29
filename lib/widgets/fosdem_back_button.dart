import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:fosdem/utils/style.dart';

class FosdemBackButton extends StatelessWidget {
  const FosdemBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Icon(Icons.arrow_back_ios_new, color: fosdemBlue),
      ),
    );
  }
}
