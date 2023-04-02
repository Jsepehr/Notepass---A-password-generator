import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_pass/data_provider/data_providers.dart';
import 'package:share/share.dart';
import '../widgets/dialog_edit.dart';
import '../utility/shared_pref.dart' as sh;
import '../utility/txt_riferimento.dart';
import '../utility/db_helper.dart';

class UnPassword extends ConsumerStatefulWidget {
  final String initVal;
  final String hint;
  final int id;
  final int used;
  final VoidCallback fun;
  //final TextEditingController controller;
// ignore: use_key_in_widget_constructors
  const UnPassword({
    required this.initVal,
    //required this.controller,
    required this.hint,
    required this.id,
    required this.used,
    required this.fun,
  });
  @override
  ConsumerState<UnPassword> createState() => _UnPasswordState();
}

class _UnPasswordState extends ConsumerState<UnPassword> {
  bool _passwordVisible = false;
  bool _obsTxt = true;
  TextEditingController controller = TextEditingController();

  /* Future<void> saveToClipBoard(String testoDaSalvare) async {
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
    DBhelper.updateRiga(DBhelper.tableName, {DBhelper.columnsNames[3]: 1},
        widget._id, DBhelper.columnsNames[0]);
  }*/

  @override
  Widget build(BuildContext context) {
    // debugPrint('${widget.initVal} sepehr initial value');
    if (widget.initVal != '') {
      controller.text = widget.initVal;
    }
    String comment = sh.SharedPref.getStatoDelVar() == 'eng'
        ? Txtriferimenti().getTxtHint('eng')
        : Txtriferimenti().getTxtHint('ita');
    return Center(
      child: Card(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Stack(children: [
              Positioned(
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.hint.isNotEmpty ? widget.hint : comment,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: widget.used == 0
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
                  controller: controller,
                  textAlign: TextAlign.left,
                  //initialValue: widget.controller.text,
                  readOnly: true,
                  obscureText: _obsTxt ? true : false,
                  style: const TextStyle(
                      letterSpacing: 5, fontSize: 20, color: Colors.grey),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => ShowMeDialog()
                        .showMyDialogEdit(context, widget.initVal, widget.id,
                            widget.hint, ref)
                        .then((value) {
                      widget.fun();
                    }),
                    child: Text(
                      Txtriferimenti()
                          .getTxtEdit(sh.SharedPref.getStatoDelVar() ?? "eng"),
                    ),
                  ),
                  /*ElevatedButton(
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
                  ),*/
                  ElevatedButton(
                    onPressed: () {
                      Share.share(widget.initVal);
                      DBhelper.updateRiga(
                          tableName: DBhelper.tableName,
                          nameValue: {DBhelper.columnsNames[3]: 1},
                          whereArg: widget.id,
                          whereColumn: DBhelper.columnsNames[0]);
                      ref.invalidate(proPwdListProvider);
                      //Navigator.of(context).pushNamed(Routs().getrouts("load"))
                    },
                    child: Text(
                      Txtriferimenti()
                          .getTxtCopy(sh.SharedPref.getStatoDelVar() ?? "eng"),
                    ),
                  ),
                ],
              ),
            ),

            //const Divider(thickness: 5),
          ],
        ),
      ),
    );
  }
}
