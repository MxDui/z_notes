import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const PhotoNoteApp());
}

class PhotoNoteApp extends StatelessWidget {
  const PhotoNoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoNote for Gen Z',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      routes: routes,
    );
  }
}
