import 'package:flutter/material.dart';
import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';

AppBar customAppBar(String title, bool isBack) {
  return AppBar(
    title: T(title, 20.0),
    backgroundColor: decentGrey,
    elevation: 2.0,
    automaticallyImplyLeading: isBack,
  );
}
