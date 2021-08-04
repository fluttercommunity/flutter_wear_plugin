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
            builder: (
              context,
              shape,
            ) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Shape: ${shape == WearShape.round ? 'round' : 'square'}',
                  ),
                  AmbientMode(
                    builder: (context, mode) {
                      return Text(
                        'Mode: ${mode == WearMode.active ? 'Active' : 'Ambient'}',
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
