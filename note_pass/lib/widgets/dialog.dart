import 'package:flutter/material.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import '../utility/file_creation.dart';
import '../utility/utility_functions.dart';
import '../utility/shared_pref.dart' as sh;

Future<void> showMyDialog(c, showDialogCase, [h1, h2]) async {
  String strWarning = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strWarningEng
      : Txtriferimenti.strWarningIta;
  String strWarningTitle = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strWarningEngTitle
      : Txtriferimenti.strWarningItaTitle;
  String strExport = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strExportEng
      : Txtriferimenti.strExportIta;
  String strExportTitle = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strExportTitleEng
      : Txtriferimenti.strExportTitleIta;
  return showDialog<void>(
    context: c,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.yellow,
        title: Text(showDialogCase == ShowDialogCase.image
            ? Txtriferimenti()
                .getTxtGen(sh.SharedPref.getStatoDelVar() ?? "eng")
            : showDialogCase == ShowDialogCase.export
                ? strExportTitle
                : showDialogCase == ShowDialogCase.warning
                    ? strWarningTitle
                    : ''),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                showDialogCase == ShowDialogCase.image
                    ? Txtriferimenti().getTxtAvvisoGen(
                        sh.SharedPref.getStatoDelVar() ?? "eng")
                    : showDialogCase == ShowDialogCase.export
                        ? strExport
                        : showDialogCase == ShowDialogCase.warning
                            ? strWarning
                            : '',
              ),
            ],
          ),
        ),
        actions: <Widget>[
          showDialogCase != ShowDialogCase.warning
              ? TextButton(
                  child: Text(
                    Txtriferimenti()
                        .getTxtAnnulla(sh.SharedPref.getStatoDelVar() ?? "eng"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          showDialogCase != ShowDialogCase.warning
              ? TextButton(
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
                )
              : TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
        ],
      );
    },
  );
}
