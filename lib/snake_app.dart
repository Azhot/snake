import 'package:flutter/material.dart';
import 'package:snake/shared/strings.dart';
import 'package:snake/screen/home/snake_home_page.dart';

class SnakeApp extends StatelessWidget {
  // constructors
  const SnakeApp({Key? key}) : super(key: key);

  // overrides
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        home: SnakeHomePage(),
      );
}
