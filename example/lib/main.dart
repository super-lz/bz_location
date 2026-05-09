import 'dart:async';

import 'package:bz_location/bz_location.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  final List<String> _logs = <String>[];
  StreamSubscription<Map<String, Object>>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey('your-android-key', 'your-ios-key');
    _locationPlugin.setLocationOption(
      AMapLocationOption(
        onceLocation: false,
        needAddress: true,
      ),
    );
    _locationSubscription = _locationPlugin.onLocationChanged().listen((event) {
      setState(() {
        _logs.insert(0, event.toString());
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _locationPlugin.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('bz_location example'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _locationPlugin.startLocation,
                    child: const Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: _locationPlugin.stopLocation,
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(_logs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
