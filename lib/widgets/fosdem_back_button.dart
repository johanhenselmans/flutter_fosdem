import 'package:flutter/material.dart';
import 'package:fosdem/utils/style.dart';

class FosdemBackButton extends StatelessWidget {
  const FosdemBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: const Icon(Icons.arrow_back_ios_new, color: fosdemBlue),
      ),
    );
  }
}
