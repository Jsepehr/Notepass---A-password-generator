import 'package:flutter/material.dart';
import 'package:note_pass/widgets/shared_widgets/floating_button.dart';
import '../utility/txt_riferimento.dart';
import '../utility/utility_functions.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/dialog.dart';
import '../utility/shared_pref.dart' as sh;

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  dynamic _strHash;
  String? _imgHash;
  int _selColor = 2;
  bool _nullOrNotStr = true;
  final _userPasswordController = TextEditingController();
  bool _passwordVisible = false;
  String? linguaggio = sh.SharedPref.getStatoDelVar() ?? "eng";

  Future<void> getPicHash() async {
    final first = ImagePicker();
    final imageFile = await first.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      setState(() {
        _selColor = 0;
      });
      return;
    }
    File storedImage = File(imageFile.path);
    String hash = await generateImageHash(storedImage);
    setState(() {
      _selColor = 1;
      _imgHash = hash;
    });
  }

  TextStyle txtColor(int val) {
    switch (val) {
      case 1:
        return const TextStyle(color: Color.fromARGB(255, 48, 180, 0));
      case 2:
        return const TextStyle(color: Colors.blue);
      default:
        return const TextStyle(color: Color.fromARGB(255, 203, 0, 0));
    }
  }

  BorderSide borderColor(int val) {
    switch (val) {
      case 1:
        return const BorderSide(color: Color.fromARGB(255, 48, 180, 0));
      case 2:
        return const BorderSide(color: Colors.blue);
      default:
        return const BorderSide(color: Color.fromARGB(255, 203, 0, 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    String lingua = sh.SharedPref.getStatoDelVar() ?? 'eng';
    String str1 = lingua == 'eng'
        ? Txtriferimenti.strConf1Eng
        : Txtriferimenti.strConf1Ita;
    String str2 = lingua == 'eng'
        ? Txtriferimenti.strConf2Eng
        : Txtriferimenti.strConf2Ita;
    String str3 = lingua == 'eng'
        ? Txtriferimenti.strConf3Eng
        : Txtriferimenti.strConf3Ita;
    String str4 = lingua == 'eng'
        ? Txtriferimenti.strConf4Eng
        : Txtriferimenti.strConf4Ita;
    String str5 = lingua == 'eng'
        ? Txtriferimenti.strConf5Eng
        : Txtriferimenti.strConf5Ita;
    return Scaffold(
      resizeToAvoidBottomInset: true, // fluter 1.x// fluter 2.x
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? const NotePassFloatingActionBtn(strVar: "pass")
          : Container(),
      appBar: AppBar(
        title: Text(
          Txtriferimenti().getTxtTestata("config"),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Card(
                  elevation: 1,
                  color: NotePassColors.descriptionBg,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Txtriferimenti.descrizioneConfig(
                        context, str1, str2, str3, str5, str4),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                OutlinedButton(
                  // image button---------------------------------------------------
                  style: OutlinedButton.styleFrom(
                    side: borderColor(_selColor),
                  ),
                  onPressed: () {
                    _imgHash = getPicHash().toString();
                  },
                  child: Text(
                    Txtriferimenti().getTxtImmage(linguaggio),
                    style: txtColor(_selColor),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  //keyword input---------------------------------------------------
                  keyboardType: TextInputType.text,
                  controller: _userPasswordController,
                  obscureText: !_passwordVisible,
                  //This will obscure text dynamically
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: _nullOrNotStr ? Colors.blue : Colors.red)),
                    labelText: Txtriferimenti().getTxtInputTestata(
                        sh.SharedPref.getStatoDelVar() ?? "eng"),
                    hintText: Txtriferimenti().getTxtInputHint(
                        sh.SharedPref.getStatoDelVar() ?? "eng"),
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  //generate button ------------------------------------------
                  onPressed: () {
                    _strHash = generateStringHash(_userPasswordController.text);
                    if (_imgHash == null) {
                      setState(() {
                        _selColor = 0;
                      });
                    } else if (_strHash == null) {
                      setState(() {
                        _nullOrNotStr = false;
                      });
                    } else {
                      setState(() {
                        _nullOrNotStr = true;
                      });
                      showMyDialog(
                          context, ShowDialogCase.image, _imgHash, _strHash);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      Txtriferimenti().getTxtDone(linguaggio),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
