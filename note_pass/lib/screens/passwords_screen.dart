import 'package:flutter/material.dart';
import 'package:note_pass/utility/passwords_provider.dart';
import '../utility/shared_pref.dart' as sh;
import 'package:note_pass/widgets/edit_passwords.dart';
import 'package:note_pass/widgets/shared_widgets/floating_button.dart';
import 'package:provider/provider.dart';
import '../utility/txt_riferimento.dart';
import '../widgets/dialog.dart';
import '../utility/utility_functions.dart';

// ignore: must_be_immutable
class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({Key? key}) : super(key: key);

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  String exportBtnStr = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strExportBtnEng
      : Txtriferimenti.strExportBtnIta;
  @override
  void initState() {
    Passwords().prepareData();
    //print('$passwords initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List psList = [];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? const NotePassFloatingActionBtn(strVar: "pass")
          : Container(),
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.white)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: (() => showMyDialog(context, ShowDialogCase.export)),
                child: Text(exportBtnStr),
              ),
            ),
          ),
        ],
        title: Text(Txtriferimenti().getTxtTestata("pass")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Passwords().searchField(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Consumer<Passwords>(builder: (context, password, child) {
                  password.prepareData().then((value) => psList = value);
                  return ListView(
                    children: [
                      ...psList
                          .map((e) => UnPassword(e.pwd, e.hint, e.id, e.flag))
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
