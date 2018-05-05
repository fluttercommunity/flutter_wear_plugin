import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wear example app'),
        ),
        body: new Center(
          child: new WatchShape(
              builder: (context, shape) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Shape: ${shape == Shape.round ? 'round' : 'square'}',
                        ),
                        AmbientMode(
                            builder: (context, mode) => new Text(
                                  'Mode: ${mode == Mode.active ? "Active" : "Ambient"}',
                                )),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
