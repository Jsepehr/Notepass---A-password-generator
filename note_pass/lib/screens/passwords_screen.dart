import 'package:flutter/material.dart';
import 'package:note_pass/utility/file_creation.dart';
import 'package:provider/provider.dart';
import '../utility/txt_riferimento.dart';
import '../widgets/edit_passwords.dart';
import '../utility/utility_functions.dart';
import '../utility/db_helper.dart';
import '../screens/loading_screen.dart';

class PasswordsScreen extends StatelessWidget with ChangeNotifier {
  PasswordsScreen({Key? key}) : super(key: key);

  List<PwdEnt>? tmp;
  List<PwdEnt>? tmpFiltered;
  List args1 = [];
  String? val;
  bool listLen = false;

  prepareData({String? query = ''}) async {
    if (query == '' || query == null) {
      args1 = await DBhelper.getData();
      tmp = args1
          .map((e) => PwdEnt(
              passId: e["id"],
              corpo: e["Corpo_P"],
              hint: e["Hint_P"],
              flagUsed: e["used"]))
          .toList();
    } else {
      args1 = await DBhelper.filterByHint(query);
      tmp = args1
          .map((e) => PwdEnt(
              passId: e["id"],
              corpo: e["Corpo_P"],
              hint: e["Hint_P"],
              flagUsed: e["used"]))
          .toList();
    }
    tmp!.isEmpty ? listLen = true : listLen = false;
    notifyListeners();
  }

  Widget searchField() {
    return TextField(
      onChanged: (value) {
        debugPrint(value);
        prepareData(query: value);
      },
      cursorHeight: 20,
      autofocus: false,
      //controller: TextEditingController(text: val),
      decoration: InputDecoration(
        //labelText: 'Search',
        hintText: 'Comments...',
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 215, 215, 215),
        ),
        prefixIcon: const Icon(Icons.search),
        // suffixIcon: Icon(Icons.keyboard_arrow_down),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 215, 215, 215), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 215, 215, 215), width: 1.5),
        ),
        /*focusedBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),*/
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //prepareData();
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
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (() => FileCreation().wrightContent()),
                      child: const Text('Export all'),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: searchField(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Consumer(
                        builder: (context, value, child) => ListView(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            if (!listLen)
                              ...ListV().getList(tmp)
                            else
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text('No match Found!')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

class ListV {
  getList(tmp1) {
    return tmp1
        .map(
          (e) => UnPassword(e.pwd, e.hint, e.id, e.flag),
        )
        .toList();
  }
}
