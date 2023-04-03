import 'package:note_pass/utility/utility_functions.dart';

import '../utility/txt_riferimento.dart';
import 'package:flutter/material.dart';
import '../utility/shared_pref.dart' as sh;

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String linguaggio = sh.SharedPref.getStatoDelVar() ?? "eng";

    return Scaffold(
      appBar: AppBar(
        title: Text(Txt.getTxtTestata("about")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Card(
            elevation: 1,
            color: NotePassColors.descriptionBg,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                Txt.getTxtAbout(linguaggio),
                style: const TextStyle(fontSize: 16, height: 1.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
