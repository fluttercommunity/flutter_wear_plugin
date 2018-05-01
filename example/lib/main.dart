import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wear/wear.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new WatchShape(
              builder: (context, shape) => new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                          'Shape: ${shape == Shape.round ? 'round' : 'square'}'),
                      new AppState(),
                      new AmbientMode(
                          builder: (context, mode) => new Text(
                              '${mode == Mode.active ? "Active" : "Ambient"}'))
                    ],
                  )),
        ),
      ),
    );
  }
}

class AppState extends StatefulWidget {
  @override
  createState() => new _MyAppState();
}

class _MyAppState extends State<AppState> {
  String _platformVersion = 'Unknown';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Wear.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Running on: $_platformVersion\n');
  }
}
