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
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            foregroundDecoration: const BoxDecoration(
              //color: Colors.amber,
              image: DecorationImage(
                image: AssetImage("dev_assets/lucchettoBg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Card(
                elevation: 0,
                color: const Color.fromARGB(115, 219, 239, 255),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    Txtriferimenti().getTxtAbout(linguaggio),
                    style: const TextStyle(fontSize: 16, height: 1.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
