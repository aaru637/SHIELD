import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield/Home_Screens/Home_Page.dart';
import 'package:shield/Screens/Register.dart';

import 'Reusable/Reusable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash_Screen(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.containsKey("name")) {
          String Name = sharedPreferences.getString("name")!;
          debugPrint(Name);
          if (sharedPreferences.getString("name") == "no user") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Register_Page(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Home_Page(
                      Name: Name,
                    )));
            Reusable.Success("Keep Location Anytime...", context);
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Register_Page(),
            ),
          );
          Reusable.Success("Keep Location Anytime...", context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("SHIELD"),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
