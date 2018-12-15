import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'root_page.dart';
import 'auth.dart';

void main() => runApp(CatTrack());

class CatTrack extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Track',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.purple,
      ),
      home: RootPage(auth: Auth())
    );
  }
}

