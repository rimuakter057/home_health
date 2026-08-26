import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';


class Label extends StatelessWidget {
  final String text;
  const Label(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.labelMedium,
    );
  }
}