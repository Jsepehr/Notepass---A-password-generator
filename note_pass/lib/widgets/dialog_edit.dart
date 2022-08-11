import 'package:flutter/material.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import '../utility/db_helper.dart';
import '../utility/notepass_routs.dart';
import '../utility/shared_pref.dart' as sh;

class ShowMeDialog {
  String? _input, _hint;

  Future<void> showMyDialogEdit(c, initVal, id, hint) async {
    return showDialog<void>(
      context: c,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Text(
            Txtriferimenti()
                .getTxtEdit(sh.SharedPref.getStatoDelVar() ?? "eng"),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  // passwird input
                  onChanged: (input) => _input = input,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        Icons.edit,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: null,
                    ),
                  ),
                  textAlign: TextAlign.left,
                  initialValue: initVal,
                  readOnly: false,
                  style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                TextFormField(
                  // passwird input
                  initialValue: hint,
                  onChanged: (input) => _hint = input,
                  decoration: InputDecoration(
                    hintText:
                        "${Txtriferimenti().getTxtHint(sh.SharedPref.getStatoDelVar() ?? "eng").toString()}...",
                  ),
                  textAlign: TextAlign.left,
                  readOnly: false,
                  style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Txtriferimenti()
                  .getTxtAnnulla(sh.SharedPref.getStatoDelVar() ?? "eng")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(Txtriferimenti()
                  .getTxtSalva(sh.SharedPref.getStatoDelVar() ?? "eng")),
              onPressed: () {
                if (_hint == null && _input == null) {
                  Navigator.of(context).pop();
                } else if (_input != null && _hint == null) {
                  DBhelper.updateRiga(
                      DBhelper.tableName,
                      {DBhelper.collumsNames[1]: _input},
                      id,
                      DBhelper.collumsNames[0]);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routs().getrouts("load"), (_) {
                    return false;
                  });
                } else if (_hint != null && _input == null) {
                  DBhelper.updateRiga(
                      DBhelper.tableName,
                      {DBhelper.collumsNames[2]: _hint},
                      id,
                      DBhelper.collumsNames[0]);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routs().getrouts("load"), (_) {
                    return false;
                  });
                } else {
                  DBhelper.updateRiga(
                      DBhelper.tableName,
                      {DBhelper.collumsNames[1]: _input},
                      id,
                      DBhelper.collumsNames[0]);
                  DBhelper.updateRiga(
                      DBhelper.tableName,
                      {DBhelper.collumsNames[2]: _hint},
                      id,
                      DBhelper.collumsNames[0]);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routs().getrouts("load"), (_) {
                    return false;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
