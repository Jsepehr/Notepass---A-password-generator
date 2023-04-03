import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_pass/data_provider/data_providers.dart';
import '../model/pwd.dart';
import '../utility/txt_riferimento.dart';
import '../utility/notepass_routs.dart';
import '../utility/utility_functions.dart';
import '../utility/db_helper.dart';
//import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import '../utility/shared_pref.dart' as sh;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool colors = false;
  bool? _giaEntrato;
  @override
  void initState() {
    linguaggio = sh.SharedPref.getStatoDelVar() ?? 'eng';
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAndSetPasswords());
    Future.delayed(const Duration(milliseconds: 100), () {
      // Do something
      _giaEntrato = ref.watch(proGiaEntratoProvider.notifier).state;
    });
    super.initState();
  }

  Future<void> localAuth(
      BuildContext context, String whereTogo, WidgetRef ref) async {
    final localAuth = LocalAuthentication();
    final List<Pwd> data = await ref.watch(proPwdListProvider.future);
    final didAuthenticate = await localAuth.authenticate(
      localizedReason: 'Please authenticate',
      options: const AuthenticationOptions(
          biometricOnly: true, useErrorDialogs: true, stickyAuth: true),
    );
    if (didAuthenticate && data.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(Routs.getrouts(whereTogo),
          (_) {
        return false;
      });
    }
  }

  final Uri _url = Uri.parse('https://www.youtube.com/watch?v=gbT-1kaqTXI');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      showHint('Somthing went wrong');
    }
  }

  List<Pwd> dataList = [];

  Future fetchAndSetPasswords() async {
    dataList = await ref.watch(proPwdListProvider.future) ?? [];
    setState(() {
      colors = dataList.isEmpty;
    });
  }

  String? lingua = sh.SharedPref.getStatoDelVar() ?? 'eng';
  String linguaggio = '';
  //per eseguire fetchAndSetPasswords() una volta quando app viene comletamente renderizzato

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Txt.getTxtTestata("home")),
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
                const SizedBox(
                  height: 15,
                ),
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
                const SizedBox(height: 15),
                Card(
                  elevation: 1,
                  color: NotePassColors.descriptionBg,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Txt.getTxtDesLangHome(linguaggio)),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: colors
                        ? const BorderSide(color: Colors.blue)
                        : const BorderSide(
                            color: Color.fromARGB(255, 173, 173, 173)),
                  ),
                  onPressed: () async {
                    final check = await checkDeviceAuth();
                    if (_giaEntrato == false) {
                      if (!check) {
                        if (!mounted) {
                          return;
                        }
                        dialogBuilder(
                            context: context,
                            cancelText: Txt.getTxtDoneLockScreen(linguaggio),
                            text: Txt.getTxtScreenLock(linguaggio),
                            title: 'Warning',
                            func: () {
                              AppSettings.openSecuritySettings();
                            },
                            functionOnCancel: () {},
                            action: 'Go to settings');
                        return;
                      }
                      final checkAuth = await authenticate();
                      if (checkAuth) {
                        DBhelper.updateRiga(
                            tableName: DBhelper.tableName,
                            nameValue: {DBhelper.columnsNames[3]: 0},
                            whereArg: 1,
                            whereColumn: DBhelper.columnsNames[3]);
                        ref.invalidate(proPwdListProvider);
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routs.getrouts("config"), (_) {
                          return false;
                        });
                      } else {
                        if (!mounted) {
                          return;
                        }
                        dialogBuilder(
                            context: context,
                            text: 'Authentication failed',
                            title: 'Warning',
                            func: () {},
                            functionOnCancel: () {},
                            action: '');
                      }
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routs.getrouts("config"), (_) {
                        return false;
                      });
                    }
                  },
                  child: Text(
                    Txt.getTxtConfiguration(linguaggio),
                    style: TextStyle(
                        color: !colors
                            ? const Color.fromARGB(255, 173, 173, 173)
                            : Colors.blue),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (dataList.isEmpty) {
                      final check = await checkDeviceAuth();
                      if (_giaEntrato == false) {
                        if (!check) {
                          if (!mounted) {
                            return;
                          }
                          dialogBuilder(
                              context: context,
                              cancelText: Txt.getTxtDoneLockScreen(linguaggio),
                              text: Txt.getTxtScreenLock(linguaggio),
                              title: 'Warning',
                              func: () {
                                AppSettings.openSecuritySettings();
                              },
                              functionOnCancel: () {},
                              action: 'Go to settings');
                          return;
                        }
                        final checkAuth = await authenticate();
                        if (checkAuth) {
                          DBhelper.updateRiga(
                              tableName: DBhelper.tableName,
                              nameValue: {DBhelper.columnsNames[3]: 0},
                              whereArg: 1,
                              whereColumn: DBhelper.columnsNames[3]);
                          ref.invalidate(proPwdListProvider);
                          if (!mounted) {
                            return;
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routs.getrouts("config"), (_) {
                            return false;
                          });
                        } else {
                          if (!mounted) {
                            return;
                          }
                          dialogBuilder(
                              context: context,
                              text: 'Authentication failed',
                              title: 'Warning',
                              func: () {},
                              functionOnCancel: () {},
                              action: '');
                        }
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routs.getrouts("config"), (_) {
                          return false;
                        });
                      }
                    } else if (dataList.isNotEmpty) {
                      final check = await checkDeviceAuth();
                      if (_giaEntrato == false) {
                        if (!check) {
                          if (!mounted) {
                            return;
                          }
                          dialogBuilder(
                              context: context,
                              cancelText: Txt.getTxtDoneLockScreen(linguaggio),
                              text: Txt.getTxtScreenLock(linguaggio),
                              title: 'Warning',
                              func: () {
                                AppSettings.openSecuritySettings();
                              },
                              functionOnCancel: () {},
                              action: 'Go to settings');
                          return;
                        }
                        final checkAuth = await authenticate();
                        if (checkAuth) {
                          DBhelper.updateRiga(
                              tableName: DBhelper.tableName,
                              nameValue: {DBhelper.columnsNames[3]: 0},
                              whereArg: 1,
                              whereColumn: DBhelper.columnsNames[3]);
                          ref.invalidate(proPwdListProvider);
                          if (!mounted) {
                            return;
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routs.getrouts("pass"), (_) {
                            return false;
                          });
                        } else {
                          if (!mounted) {
                            return;
                          }
                          dialogBuilder(
                              context: context,
                              text: 'Authentication failed',
                              title: 'Warning',
                              func: () {},
                              functionOnCancel: () {},
                              action: '');
                        }
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routs.getrouts("pass"),
                          (_) {
                            return false;
                          },
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: colors
                          ? MaterialStateProperty.all(
                              const Color.fromARGB(255, 234, 234, 234))
                          : MaterialStateProperty.all(Colors.blue)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      Txt.getTxtPwd(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(Routs.getrouts("about")),
                      child: const Text(
                        "About",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _launchUrl(),
                      child: const Text(
                        "Tutorial",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
