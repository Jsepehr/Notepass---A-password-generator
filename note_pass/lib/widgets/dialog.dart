import 'package:flutter/material.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import '../utility/file_creation.dart';
import '../utility/utility_functions.dart';
import '../utility/shared_pref.dart' as sh;

Future<void> showMyDialog(c, showDialogCase, [h1, h2]) async {
  return showDialog<void>(
    context: c,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.yellow,
        title: Text(Txtriferimenti()
            .getTxtGen(sh.SharedPref.getStatoDelVar() ?? "eng")),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              //rendere questo dinamico
              Text(
                showDialogCase == ShowDialogCase.image
                    ? Txtriferimenti().getTxtAvvisoGen(
                        sh.SharedPref.getStatoDelVar() ?? "eng")
                    : showDialogCase == ShowDialogCase.import
                        ? 'Wrong file format'
                        : showDialogCase == ShowDialogCase.export
                            ? 'The file will save in your Downloads folder as "Notepass_pwdc**.txt"'
                            : showDialogCase == ShowDialogCase.warning
                                ? 'Wrong file name or format!'
                                : '',
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
              if (showDialogCase == ShowDialogCase.image &&
                  h1 != null &&
                  h2 != null) {
                Navigator.of(context).pushReplacementNamed(
                  "/",
                  arguments: Args(h1, h2, "gen"),
                );
              } else if (showDialogCase == ShowDialogCase.export) {
                FileCreation().wrightContentToFile();
                Navigator.of(context).pop();
              } else if (showDialogCase == ShowDialogCase.warning) {
                Navigator.of(context).pop();
              } /* else {
                Navigator.of(context).pushReplacementNamed('/');
              }*/
            },
          ),
        ],
      );
    },
  );
}
