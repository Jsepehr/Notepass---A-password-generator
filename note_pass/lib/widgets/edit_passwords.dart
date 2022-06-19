import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/dialog_edit.dart';
import '../utility/shared_pref.dart' as sh;
import '../utility/txt_riferimento.dart';
import '../utility/db_helper.dart';

class UnPasswoed extends StatefulWidget {
  final String _initVal;
  final String _hint;
  final int _id;
  final int _used;

// ignore: use_key_in_widget_constructors
  const UnPasswoed(this._initVal, this._hint, this._id, this._used);
  @override
  State<UnPasswoed> createState() => _UnPasswoedState();
}

class _UnPasswoedState extends State<UnPasswoed> {
  bool _passwordVisible = false;
  bool _obsTxt = true;

  Future<void> saveToClipBoard(String testoDaSalvare) async {
    ClipboardData data = ClipboardData(text: testoDaSalvare);
    await Clipboard.setData(data);
    await Fluttertoast.showToast(
        msg: Txtriferimenti()
            .getTxtToastCopied(sh.SharedPref.getStatoDelVar() ?? "eng"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(150, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
    DBhelper.updateRiga(DBhelper.tableName, {DBhelper.collumsNames[3]: 1},
        widget._id, DBhelper.collumsNames[0]);
  }

  showHint(String hint) {
    Fluttertoast.showToast(
        msg: hint,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(150, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: widget._used == 0
                        ? Theme.of(context).primaryColorDark
                        : Colors.amber.shade800,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                      _obsTxt = !_obsTxt;
                    });
                  },
                ),
              ),
              textAlign: TextAlign.left,
              initialValue: widget._initVal,
              readOnly: true,
              obscureText: _obsTxt ? true : false,
              style: const TextStyle(
                  letterSpacing: 5, fontSize: 20, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => ShowMeDialog().showMyDialogEdit(
                      context, widget._initVal, widget._id, widget._hint),
                  child: Text(
                    Txtriferimenti()
                        .getTxtEdit(sh.SharedPref.getStatoDelVar() ?? "eng"),
                  ),
                ),
                ElevatedButton(
                  style: widget._hint.isEmpty
                      ? ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey.shade300))
                      : ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                  onPressed: () =>
                      widget._hint == "" ? null : showHint(widget._hint),
                  child: Text(
                    Txtriferimenti()
                        .getTxtHint(sh.SharedPref.getStatoDelVar() ?? "eng"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => saveToClipBoard(widget._initVal),
                  child: Text(
                    Txtriferimenti()
                        .getTxtCopy(sh.SharedPref.getStatoDelVar() ?? "eng"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
