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
  preparaData() async {
    debugPrint("preparaladata");
    args1 = await DBhelper.getData(DBhelper.tableName);
    tmp = args1
        .map((e) => PwdEnt(
            passId: e["id"],
            corpo: e["Corpo_P"],
            hint: e["Hint_P"],
            falgUsed: e["used"]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preparaData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        preparaData();
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
