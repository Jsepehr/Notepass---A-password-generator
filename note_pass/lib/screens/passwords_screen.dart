import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../utility/txt_riferimento.dart';
import '../widgets/edit_passwords.dart';
import '../utility/utility_functions.dart';
import '../utility/db_helper.dart';
import '../screens/loading_screen.dart';

class PasswordsScreen extends StatefulWidget {
  const PasswordsScreen({Key? key}) : super(key: key);

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  List<PwdEnt>? tmp;
  List args1 = [];
  prepareData() async {
    //debugPrint("prepareData");
    args1 = await DBhelper.getData(DBhelper.tableName);
    tmp = args1
        .map((e) => PwdEnt(
            passId: e["id"],
            corpo: e["Corpo_P"],
            hint: e["Hint_P"],
            flagUsed: e["used"]))
        .toList();
    var tempNotEmpty = tmp!.where((e) => e.hint != '').toList();
    var tempEmpty = tmp!.where((e) => e.hint == '').toList();
    tempNotEmpty
        .sort(((a, b) => a.hint.toLowerCase().compareTo(b.hint.toLowerCase())));
    tmp = List.from(tempNotEmpty)..addAll(tempEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        prepareData();
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/", (_) {
                  return false;
                }, arguments: Args(null, null, "pass"));
              },
              child: const Icon(Icons.home),
            ),
            appBar: AppBar(
              title: Text(Txtriferimenti().getTxtTestata("pass")),
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height * 0.79,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: tmp!
                    .map(
                      (e) => UnPassword(e.pwd, e.hint, e.id, e.flag),
                    )
                    .toList(),
              ),
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
