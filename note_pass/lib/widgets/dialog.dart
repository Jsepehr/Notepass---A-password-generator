import 'package:flutter/material.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import '../utility/utility_functions.dart' as util;
import '../utility/shared_pref.dart' as sh;

Future<void> showMyDialog(c, h1, h2) async {
  return showDialog<void>(
    context: c,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.yellow,
        title: Text(Txtriferimenti()
            .getTxtGen(sh.SharedPref.getStatoDelVar() ?? "eng"),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                Txtriferimenti()
                    .getTxtAvvisoGen(sh.SharedPref.getStatoDelVar() ?? "eng"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              Txtriferimenti()
                  .getTxtAnnulla(sh.SharedPref.getStatoDelVar() ?? "eng"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              Txtriferimenti()
                  .getTxtApprova(sh.SharedPref.getStatoDelVar() ?? "eng"),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                "/",
                arguments: util.Args(h1, h2, "gen"),
              );
            },
          ),
        ],
      );
    },
  );
}
