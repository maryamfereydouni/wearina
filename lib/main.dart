import 'package:flutter/material.dart';
import 'package:wearina/models/onboard.dart';
import 'package:wearina/pages/main_screen/main_screen.dart';
// import 'package:wearina/pages/main_screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int active = 0;
  // GlobalKey<ScaffoldState> state = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (c) => const Home())));
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: wi,
        height: he,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft),
        ),
        child: Column(children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: he * .15),
            child: CircleAvatar(
              maxRadius: 75,
              backgroundImage: NetworkImage(
                  "data:image/jpeg;base64,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"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: he * .05),
            child: Text(
              "Wearina",
              style: TextStyle(color: Colors.white, fontSize: wi * .05),
            ),
          )
        ]),
      ),
    );
  }
}
