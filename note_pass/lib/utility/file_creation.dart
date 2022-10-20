import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import 'package:note_pass/utility/utility_functions.dart';
import 'package:note_pass/widgets/dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utility/shared_pref.dart' as sh;

import 'db_helper.dart';

class FileCreation {
  String hintSaved = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strHintEng
      : Txtriferimenti.strHintIta;
  String hintReady = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strHintGenEng
      : Txtriferimenti.strHintGenIta;
  List<PwdEnt> pwdList = [];
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future get _localPath async {
    if (await _requestPermission(Permission.storage)) {
      final directory = await AndroidPathProvider.downloadsPath;
      return directory;
    }
  }

  Future<File> get _localFile async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMddkkmm').format(now);
    final path = await _localPath;

    return File('$path/Notepass_pwdc$formattedDate.txt');
  }

  void wrightContentToFile() async {
    List data = await DBhelper.getData();
    final file = await _localFile;
    String result = '';

    for (var element in data) {
      result +=
          '${element['Hint_P'] == '' ? 'vuoto' : element['Hint_P']}<|||>${element['Corpo_P']}<|||>';
    }
    file.writeAsString(result);
    showHint(hintSaved);
  }

  void readContentAndRightToDB(BuildContext c) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    final file = result.files;
    int i = 0;
    String fileName = file[0].name;
    RegExp exp = RegExp(r'Notepass_pwdc\d{5,}\.txt');
    if (file[0].extension! == 'txt' && exp.firstMatch(fileName) != null) {
      var myFile = await File(file[0].path!).readAsString();
      List fileContent = splitList(myFile.split('<|||>'), 2);

      for (var item in fileContent) {
        i++;
        pwdList.add(PwdEnt(
            passId: i,
            corpo: item[1],
            hint: item[0] == 'vuoto' ? '' : item[0],
            flagUsed: 0));
      }
      DBhelper.delete(DBhelper.tableName);
      for (var element in pwdList) {
        DBhelper.insert(DBhelper.tableName, {
          "id": element.id,
          "Corpo_p": element.pwd,
          "Hint_p": element.hint,
          "used": element.flag
        }).then((value) {
          showHint(hintReady);
          Navigator.of(c).pushNamedAndRemoveUntil("/", (_) {
            return false;
          }, arguments: Args(null, null, "pass"));
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      showMyDialog(c, ShowDialogCase.warning);
    }
  }
}
