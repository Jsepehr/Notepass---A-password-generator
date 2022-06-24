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
        title: Text(Txtriferimenti().getTxtTestata("about")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    )),
                child: Text(
                  Txtriferimenti().getTxtAbout(linguaggio),
                  style: const TextStyle(fontSize: 16, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
