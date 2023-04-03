import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'utility_functions.dart' as utf;

//prendi stringa e fai la lista dei pwd
class CreatePasswords {
  List<String> allDonePreDB(String? digest, List<String> numsForRand) {
    List<int> seed = utf.analisiIndici(
      utf.listToString(
        utf.strToASCII(digest!),
      ),
    );
    List upAbc = utf.mescolaLista(utf.makeArrASHII(26, 65), seed);
    List lwdAbc = utf.mescolaLista(utf.makeArrASHII(26, 97), seed);
    List numbers = utf.mescolaLista(utf.makeArrASHII(10, 48), seed);
    List specialChars = utf.mescolaLista(utf.makeArrASHII(47 - 32, 32), seed);

    List<String> mescolata = utf.mescolaListaString(numsForRand, seed);
    List<String> listapsUnico =
        utf.scegli(lwdAbc, upAbc, specialChars, numbers, mescolata);
    listapsUnico = utf.spilitList(listapsUnico);

    return listapsUnico;
  }
}

List<int> makeArrASHII(int l, int fine) {
  //dovrebbe generare una lista numeri
  List<int> list = List<int>.generate(l, (i) => i + fine);
  return list;
}

//una funzione che prende una stringa e restituisce una lista di numeri
List<int> strToASCII(String s) {
  List<int> list = [];

  for (var i = 0; i < s.length; i++) {
    list.add(s.codeUnitAt(i));
  }

  return list;
}

//split list to più lists
List<String> spilitList(List listaInput) {
  List<String> listaDiListe = [];
  var listaTmp = [];
  for (var i = 0; i < listaInput.length; i++) {
    listaTmp.add(listaInput[i]);
    if ((i + 1) % 5 == 0) {
      listaDiListe.add(listaTmp.join());
      listaTmp = [];
    }
  }

  return listaDiListe;
}

dueInUno(List elle1, List elle2) {
  var listaFinale = [];
  var tmpStr = "";
  for (var i = 0; i < 50; i++) {
    tmpStr = elle1[i] + elle2[i];
    listaFinale.add(tmpStr);
    tmpStr = "";
  }
  return listaFinale;
}

// list to string
listToString(List l) {
  return l.join();
}

List<String> mescolaListaString(List listaDaMescolare, List<int> seed) {
  List<String> listaMescolata = [];

  for (var i = 0; i < seed.length; i++) {
    listaMescolata
        .add((listaDaMescolare[seed[i] % listaDaMescolare.length]).toString());
  }

  return listaMescolata;
}

List<int> mescolaLista(List listaDaMescolare, List<int> seed) {
  List<int> listaMescolata = [];

  for (var i = 0; i < seed.length; i++) {
    listaMescolata.add(listaDaMescolare[seed[i] % listaDaMescolare.length]);
  }

  return listaMescolata;
}

List<String> scegli(List a, List b, List c, List d, List seed) {
  List<String> result = [];
  int count = 0;
  for (var item in seed) {
    for (var i = 0; i < item.length; i++) {
      switch (item[i]) {
        case '0':
          result.add(String.fromCharCode(a[count % a.length]));
          break;
        case '1':
          result.add(String.fromCharCode(b[count % b.length]));
          break;
        case '2':
          result.add(String.fromCharCode(c[count % c.length]));
          break;
        case '3':
          result.add(String.fromCharCode(d[count % d.length]));
          break;
      }
      count++;
    }
  }
  return result;
}

//questo fa seed
List<int> analisiIndici(String s) {
  List<int> result = [];
  for (int i = 0; i < 10; i++) {
    switch (i) {
      case 0:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '0') {
            result.add(i);
          }
        }

        break;
      case 1:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '1') {
            result.add(i);
          }
        }
        break;
      case 2:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '2') {
            result.add(i);
          }
        }
        break;
      case 3:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '3') {
            result.add(i);
          }
        }
        break;
      case 4:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '4') {
            result.add(i);
          }
        }
        break;
      case 5:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '5') {
            result.add(i);
          }
        }
        break;
      case 6:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '6') {
            result.add(i);
          }
        }
        break;
      case 7:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '7') {
            result.add(i);
          }
        }
        break;
      case 8:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '8') {
            result.add(i);
          }
        }
        break;
      case 9:
        for (var i = 0; i < s.length; i++) {
          if (s[i] == '9') {
            result.add(i);
          }
        }
        break;
    }
  }
  return result;
}

Future<String> generateImageHash(File file) async {
  var imageByte = file.readAsBytesSync().toString();
  var bytes = utf8.encode(imageByte); // data being hashed
  String digest = sha256.convert(bytes).toString();
  return digest;
}

String? generateStringHash(String str) {
  if (str == '') return null;
  var bytes1 = utf8.encode(str); // data being hashed
  var digest1 = sha256.convert(bytes1).toString();
  return digest1;
}

// class Args {
//   final String? hash1, hash2, messaggio;
//   Args(this.hash1, this.hash2, this.messaggio);
// }

//passwords class

//the function splitList generates a list of lists
List<List<String>> splitList(List<String> input, int chunkSize) {
  final tmpLists = List<String>.filled(chunkSize, '');
  List<List<String>> result = [];

  for (int i = 0; i < input.length - 1; i = chunkSize + i) {
    for (int k = 0; k < tmpLists.length; k++) {
      tmpLists[k] = input[i + k];
    }
    result.add(tmpLists.toList());
  }
  return result;
}

enum ShowDialogCase { image, import, export, warning }

showHint(String hint) {
  Fluttertoast.showToast(
      msg: hint,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(150, 0, 0, 0),
      textColor: Colors.white,
      fontSize: 16.0);
}

class NotePassColors {
  static Color descriptionBg = const Color.fromARGB(255, 219, 239, 255);
}

// Future<Map<String, bool>> authenticate() async {
//   Map<String, bool> res = {'auth': false, 'canNot': false};
//   final LocalAuthentication auth = LocalAuthentication();
//   bool authenticated = false;
//   bool canCheck = false;
//   try {
//     canCheck = await auth.canCheckBiometrics;
//     if (!canCheck) {
//       res['canNot'] = canCheck;
//       return res;
//     }
//     authenticated = await auth.authenticate(
//       localizedReason: 'Let OS determine authentication method',
//       options: const AuthenticationOptions(
//         stickyAuth: true,
//       ),
//     );
//     res['auth'] = authenticated;
//   } on PlatformException catch (e) {
//     debugPrint(e.message);
//     res['auth'] = authenticated;
//     res['canNot'] = canCheck;
//   }
//   debugPrint('$res');
//   return res;
// }

Future<bool> checkDeviceAuth() async {
  final LocalAuthentication auth = LocalAuthentication();
  //return await auth.canCheckBiometrics;
  bool check = false;
  try {
    await auth.isDeviceSupported().then((value) {
      check = value;
    });
    debugPrint('$check   sepehr chek');
    return check;
  } catch (e) {
    debugPrint('${e.toString()}  sepehr');
    return check;
  }
}

Future<bool> authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool lockScreen = false;
  try {
    await auth
        .authenticate(
      localizedReason: 'Let OS determine authentication method',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    )
        .then((value) {
      lockScreen = value;
    });
    debugPrint('$lockScreen   sepehr');
    return lockScreen;
  } on PlatformException {
    return lockScreen;
  }
}

Future<void> dialogBuilder(
    {required BuildContext context,
    required String text,
    String? cancelText,
    required String title,
    required VoidCallback func,
    required VoidCallback functionOnCancel,
    required String action}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(cancelText ?? 'Cancel'),
            onPressed: () {
              functionOnCancel();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(action),
            onPressed: () {
              func();
            },
          ),
        ],
      );
    },
  );
}
