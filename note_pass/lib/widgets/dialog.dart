import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_pass/data_provider/data_providers.dart';
import 'package:note_pass/utility/notepass_routs.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import '../model/pwd.dart';
import '../utility/db_helper.dart';
import '../utility/file_creation.dart';
import '../utility/utility_functions.dart';
import '../utility/shared_pref.dart' as sh;

Future<void> showMyDialog(c, showDialogCase, WidgetRef ref) async {
  final h1 = ref.watch(proImgAndStrProvider)['imgHash'];
  final h2 = ref.watch(proImgAndStrProvider)['strHash'];

  print(sh.SharedPref.getStatoDelVar());
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
  print(strExport);

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
                      DBhelper.delete(DBhelper.tableName);
                      int i = 0;
                      List<Pwd> pwdList = [];
                      final createPwds = ref.watch(proCreatePwdProvider);
                      final List<String> numForRand =
                          Txtriferimenti().getTxtFixedString().split(',');
                      final hash1 = ref.watch(proImgAndStrProvider)['imgHash'];
                      final hash2 = ref.watch(proImgAndStrProvider)['strHash'];
                      var pass1 = createPwds.allDonePreDB(hash1, numForRand);
                      var pass2 = createPwds.allDonePreDB(hash2, numForRand);
                      for (var item in dueInUno(pass1, pass2)) {
                        i++;
                        pwdList.add(Pwd(
                            pwdId: i,
                            pwdCorpo: item,
                            pwdHint: '',
                            flagUsed: 0));
                      }
                      for (var element in pwdList) {
                        DBhelper.insert(DBhelper.tableName, {
                          "id": element.pwdId,
                          "password": element.pwdCorpo,
                          "hint": element.pwdHint,
                          "used": element.flagUsed
                        });
                      }
                      ref.invalidate(proPwdListProvider);

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routs.getrouts('pass'),
                        (_) {
                          return false;
                        },
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
