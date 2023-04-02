import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:note_pass/data_provider/data_providers.dart';
import 'package:note_pass/utility/txt_riferimento.dart';
import 'package:note_pass/utility/utility_functions.dart';
import 'package:note_pass/widgets/dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/pwd.dart';
import '../utility/shared_pref.dart' as sh;

import 'db_helper.dart';
import 'notepass_routs.dart';

class FileCreation {
  String hintSaved = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strHintEng
      : Txtriferimenti.strHintIta;
  String hintReady = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txtriferimenti.strHintGenEng
      : Txtriferimenti.strHintGenIta;
  List<Pwd> pwdList = [];
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
          '${element['hint'] == '' ? 'vuoto' : element['hint']}<|||>${element['password']}<|||>';
    }
    file.writeAsString(result);
    showHint(hintSaved);
  }

  void readContentAndRightToDB(BuildContext c, WidgetRef ref) async {
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
        pwdList.add(Pwd(
            pwdId: i,
            pwdCorpo: item[1],
            pwdHint: item[0] == 'vuoto' ? '' : item[0],
            flagUsed: 0));
      }
      if (ref.watch(proPwdListProvider).value!.isNotEmpty) {
        for (var element in pwdList) {
          DBhelper.updateRiga(
              tableName: DBhelper.tableName,
              nameValue: {
                "id": element.pwdId,
                "password": element.pwdCorpo,
                "hint": element.pwdHint,
                "used": element.flagUsed
              },
              whereColumn: DBhelper.columnsNames[0],
              whereArg: element.pwdId);
          // debugPrint('${element.toString()} sepehr dopo update');
        }
        showHint(hintReady);
      } else {
        for (var element in pwdList) {
          DBhelper.insert(DBhelper.tableName, {
            "id": element.pwdId,
            "password": element.pwdCorpo,
            "hint": element.pwdHint,
            "used": element.flagUsed
          });
        }
        showHint(hintReady);
      }
      ref.invalidate(proPwdListProvider);
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.of(c).pushNamedAndRemoveUntil(
          Routs.getrouts('pass'),
          (_) {
            return false;
          },
        );
      });
    } else {
      // ignore: use_build_context_synchronously
      showMyDialog(c, ShowDialogCase.warning, ref);
    }
  }
}
