import 'package:flutter/material.dart';
import 'package:note_pass/utility/utility_functions.dart';

import 'db_helper.dart';

class Passwords with ChangeNotifier {
  List _args1 = [];
  static List<PwdEnt> pList = [];
  static String query = '';

  Future<List> prepareData() async {
    _args1 = await DBhelper.filterByHint(query);
    pList = _args1
        .map((e) => PwdEnt(
            passId: e["id"],
            corpo: e["Corpo_P"],
            hint: e["Hint_P"],
            flagUsed: e["used"]))
        .toList();
    notifyListeners();

    return pList;
  }

  Widget searchField() {
    return TextField(
      onChanged: (value) {
        query = value;
      },
      cursorHeight: 20,
      autofocus: false,
      //controller: ,
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
}
