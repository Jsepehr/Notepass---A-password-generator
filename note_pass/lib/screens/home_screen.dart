import 'package:flutter/material.dart';
import '../utility/txt_riferimento.dart';
import '../utility/notepass_routs.dart';
import '../utility/utility_functions.dart';
import '../utility/db_helper.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utility/shared_pref.dart' as sh;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    linguaggio = sh.SharedPref.getStatoDelVar() ?? 'eng';
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAndSetPasswords());
    super.initState();
  }

  Future<void> localAuth(
      BuildContext context, String whereTogo, List? data) async {
    final localAuth = LocalAuthentication();
    final didAuthenticate = await localAuth.authenticate(
      localizedReason: 'Please authenticate',
      options: const AuthenticationOptions(biometricOnly: false),
    );
    if (didAuthenticate && whereTogo == "config" && data == null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(Routs().getrouts("config"),
          (_) {
        return false;
      });
    } else if (didAuthenticate && whereTogo == "pass" && data != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(Routs().getrouts("pass"),
          (_) {
        return false;
      }, arguments: data);
    }
  }

  bool _giaEntrato = false;

  showHint(String hint) {
    Fluttertoast.showToast(
        msg: hint,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(150, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  List<Map<String, Object?>>? dataList;

  Future fetchAndSetPasswords() async {
    dataList = await DBhelper.getData(DBhelper.tableName);
  }

  String? lingua = sh.SharedPref.getStatoDelVar() ?? 'eng';
  String linguaggio = '';
  //per eseguire fetchAndSetPasswords() una volta quando app viene comletamente renderizzato

  @override
  Widget build(BuildContext context) {
    List<PwdEnt> pwdList = [];

    final List<String> numsForRand =
        Txtriferimenti().getTxtFixedString().split(',');

    int i = 0;

    final args1 = ModalRoute.of(context)!.settings.arguments as Args?;

    if (args1 != null && args1.messaggio == "gen") {
      DBhelper.delete(DBhelper.tableName);
      var pass1 = allDonePreDB(args1.hash1, numsForRand);
      var pass2 = allDonePreDB(args1.hash2, numsForRand);
      for (var item in dueInUno(pass1, pass2)) {
        i++;
        pwdList.add(PwdEnt(passId: i, corpo: item, hint: '', falgUsed: 0));
      }
      for (var element in pwdList) {
        DBhelper.insert(DBhelper.tableName, {
          "id": element.id,
          "Corpo_p": element.pwd,
          "Hint_p": element.hint,
          "used": element.flag
        });
      }
      showHint(Txtriferimenti()
          .getTxtToastGenerate(sh.SharedPref.getStatoDelVar() ?? "eng"));
      _giaEntrato = true;
    } else if (args1?.messaggio == "saved") {
      showHint(Txtriferimenti()
          .getTxtToastSalvate(sh.SharedPref.getStatoDelVar() ?? "eng"));
      _giaEntrato = true;
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushNamedAndRemoveUntil(Routs().getrouts("pass"),
            (_) {
          return false;
        }, arguments: dataList);
      });
    } else if (args1?.messaggio == "pass") {
      _giaEntrato = true;
    }

    void screenLockWapper(
      context,
      String direzione,
      List? listaDati,
      String parilaChiaveFisso,
    ) {
      screenLock(
        context: context,
        correctString: parilaChiaveFisso,
        customizedButtonChild: const Icon(
          Icons.fingerprint,
        ),
        customizedButtonTap: () async {
          await localAuth(context, direzione, listaDati);
        },
        didOpened: () async {
          await localAuth(context, direzione, listaDati);
        },
      );
    }

    if (_giaEntrato == false) {
      DBhelper.updateRiga(DBhelper.tableName, {DBhelper.collumsNames[3]: 0}, 1,
          DBhelper.collumsNames[3]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Txtriferimenti().getTxtTestata("home")),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Eng"),
                    Radio<String>(
                        value: "eng",
                        groupValue: lingua,
                        onChanged: (value) async {
                          await sh.SharedPref.setStatoDelVar("eng");
                          setState(() {
                            lingua = sh.SharedPref.getStatoDelVar() ?? "eng";
                            linguaggio =
                                sh.SharedPref.getStatoDelVar() ?? "eng";
                          });
                        }),
                    const Text("Ita"),
                    Radio<String>(
                        value: "ita",
                        groupValue: lingua,
                        onChanged: (value) async {
                          await sh.SharedPref.setStatoDelVar("ita");
                          setState(() {
                            lingua = sh.SharedPref.getStatoDelVar() ?? "ita";
                            linguaggio =
                                sh.SharedPref.getStatoDelVar() ?? "ita";
                          });
                        }),
                  ],
                ),
                const SizedBox(height: 1),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      )),
                  child: Txtriferimenti().getTxtDesLangHome(linguaggio),
                ),
                const SizedBox(
                  height: 90.0,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    if (_giaEntrato == false) {
                      DBhelper.updateRiga(
                          DBhelper.tableName,
                          {DBhelper.collumsNames[3]: 0},
                          1,
                          DBhelper.collumsNames[3]);
                      screenLockWapper(context, "config", null, '7777');
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routs().getrouts("config"), (_) {
                        return false;
                      });
                    }
                  },
                  child: Text(
                    Txtriferimenti().getTxtConfiguration(linguaggio),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dataList!.isEmpty) {
                      // peobabilita n 1
                      if (_giaEntrato == false) {
                        DBhelper.updateRiga(
                            DBhelper.tableName,
                            {DBhelper.collumsNames[3]: 0},
                            1,
                            DBhelper.collumsNames[3]);
                        screenLockWapper(context, "config", null, '7777');
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routs().getrouts("config"), (_) {
                          return false;
                        });
                      }
                    } else if (dataList!.isNotEmpty) {
                      if (_giaEntrato == false) {
                        DBhelper.updateRiga(
                            DBhelper.tableName,
                            {DBhelper.collumsNames[3]: 0},
                            1,
                            DBhelper.collumsNames[3]);
                        screenLockWapper(context, "pass", dataList, '7777');
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routs().getrouts("pass"), (_) {
                          return false;
                        }, arguments: dataList);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      Txtriferimenti().getTxtPwd(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(Routs().getrouts("about")),
                    child: const Text("About")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
