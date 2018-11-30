import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: WatchShape(
              builder: (context, shape) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Shape: ${shape == Shape.round ? 'round' : 'square'}',
                      ),
                      AmbientMode(
                          builder: (context, mode) => Text(
                                'Mode: ${mode == Mode.active ? 'Active' : 'Ambient'}',
                              )),
                    ],
                  )),
        ),
      ),
    );
  }
}
