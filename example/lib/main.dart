import 'package:dotup_flutter_widgets/dotup_flutter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: WatchShape(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ListView(
              children: [
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
                Text('Shape'),
              ],
            ),
          ),
        ),
        // body: Center(
        //   child: WatchShape(
        //     builder: (context, shape, child) {
        //       return Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
        //           // monoton
        //           // audiowide
        //           // gruppo
        //           // Nanum Pen Script
        //           // style: TextStyle(fontFamily: 'Orbitron'),
        //           // if (child != null) child,
        //           // Text('dotup.de'),
        //           // DotupLogo(size: 200),
        //         ],
        //       );
        //     },
        //     // child: AmbientMode(
        //     //   builder: (context, mode, child) {
        //     //     return Text(
        //     //       'Mode: ${mode == WearMode.active ? 'Active' : 'Ambient'}',
        //     //     );
        //     //   },
        //     // ),
        //   ),
        // ),
      ),
    );
  }
}
