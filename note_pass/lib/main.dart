import 'package:flutter/material.dart';
import 'package:note_pass/screens/config_screen.dart';
import 'package:note_pass/screens/loading_screen.dart';
import 'package:note_pass/screens/passwords_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './utility/notepass_routs.dart';
import './screens/about_screen.dart';
import './screens/loading_screen.dart';
import './utility/shared_pref.dart' as sh;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //sh.SharedPref.init();
  await sh.SharedPref.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ChangeNotifierProvider(
      create: (context) => PasswordsScreen(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomeScreen(),
          Routs().getrouts("config"): (context) => const ConfigScreen(),
          Routs().getrouts("pass"): (context) =>  PasswordsScreen(),
          Routs().getrouts("about"): (context) => const About(),
          Routs().getrouts("load"): (context) => const Loading(),
        },
      ),
    );
  }
}
