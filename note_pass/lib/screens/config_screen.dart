import 'package:flutter/material.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false, // fluter 1.x// fluter 2.x
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/", (_) {
            return false;
          }, arguments: Args(null, null, "pass"));
        },
        child: const Icon(Icons.home),
      ),
      appBar: AppBar(
        title: Text(Txtriferimenti().getTxtTestata("config")),
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: Txtriferimenti().getTxtDesLangConfig(linguaggio),
                ),
                const SizedBox(
                  height: 70.0,
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
                            sh.SharedPref.getStatoDelVar() ??
                        "eng"),
                    hintText: Txtriferimenti()
                            .getTxtInputHint(sh.SharedPref.getStatoDelVar() ??
                        "eng"),
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
                  height: 60.0,
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
                      showMyDialog(context, _imgHash, _strHash);
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
