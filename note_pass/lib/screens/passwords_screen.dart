import 'package:flutter/material.dart';
import 'package:note_pass/widgets/shared_widgets/floating_button.dart';
import 'package:provider/provider.dart';
import '../utility/txt_riferimento.dart';
import '../widgets/dialog.dart';
import '../widgets/edit_passwords.dart';
import '../utility/utility_functions.dart';
import '../utility/db_helper.dart';
import '../screens/loading_screen.dart';

// ignore: must_be_immutable
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

  Future notify() async {
    listLen = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 100), () {
      listLen = false;
      print('$listLen primo');
      notifyListeners();
      // Do something
    });
    print(listLen);
  }

  Widget searchField() {
    return TextField(
      onChanged: (value) {
        prepareData(query: value);
      },
      cursorHeight: 20,
      autofocus: false,
      //controller: TextEditingController(text: val),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 226, 249, 254),
        //labelText: 'Search',
        hintText: 'Search...',
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
            floatingActionButton:
                const NotePassFloatingActionBtn(strVar: "pass"),
            appBar: AppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (() =>
                          showMyDialog(context, ShowDialogCase.export)),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: searchField(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Consumer(
                        builder: (context, value, child) => ListView.builder(
                          itemCount: tmp!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              listLen
                                  ? Container(
                                      color: Colors.grey,
                                      child: const CircularProgressIndicator(
                                        color: Color.fromARGB(255, 56, 99, 255),
                                      ))
                                  : ListV().getList(tmp)[index],
                        ),
                      ),
                    ),
                  )
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
