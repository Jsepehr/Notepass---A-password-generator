import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'db_helper.dart';

class FileCreation {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/pwdc.txt');
  }

  void wrightContent() async {
    List data = await DBhelper.getData();
    final file = await _localFile;
    String risultato = '';

    risultato += '${data.map((e) => e["Corpo_P"])}';

    /*risultato = data
        .map((e) => PwdEnt(
            passId: e["id"],
            corpo: e["Corpo_P"],
            hint: e["Hint_P"],
            flagUsed: e["used"]))
        .toList();*/
    print(risultato);
    file.writeAsString(risultato);
  }
}
