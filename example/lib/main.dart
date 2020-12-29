import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ssc_analytic/ssc_analytic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  SSCAnalytic _analytic = SSCAnalytic();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = '';
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              FlatButton(
                onPressed: () {
                  //_analytic.push(name: 'event $idx');
                  //idx += 1;
                },
                child: Text('Test push event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
