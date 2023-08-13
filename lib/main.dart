import 'package:eventsapp/ui/startpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const EventsApp());
}

class EventsApp extends StatelessWidget {
  const EventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events App',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  color: Color(0xFF30313E),
                  fontWeight: FontWeight.bold,
                  fontSize: 36.0,
                  fontFamily: "CrimsonText"),
              bodySmall: TextStyle(color: Color(0xFF7F819D), fontSize: 15.0),
              bodyMedium: TextStyle(color: Color(0xff30313E), fontSize: 15.0),
              displayMedium: TextStyle(
                  color: Color(0xFF30313E),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: "CrimsonText"))),
      home: const StartPage(),
    );
  }
}
