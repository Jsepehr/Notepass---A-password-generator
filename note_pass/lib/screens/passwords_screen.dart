import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_pass/data_provider/data_providers.dart';
import 'package:note_pass/model/pwd.dart';
import 'package:note_pass/utility/passwords_provider.dart';
import 'package:note_pass/widgets/edit_passwords.dart';
import '../utility/shared_pref.dart' as sh;
import 'package:note_pass/widgets/shared_widgets/floating_button.dart';

import '../utility/txt_riferimento.dart';
import '../widgets/dialog.dart';
import '../utility/utility_functions.dart';

// ignore: must_be_immutable
class PasswordsScreen extends ConsumerStatefulWidget {
  const PasswordsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends ConsumerState<PasswordsScreen> {
  String exportBtnStr = sh.SharedPref.getStatoDelVar() == 'eng'
      ? Txt.strExportBtnEng
      : Txt.strExportBtnIta;
  List<Pwd> pwdFiltered = [];
  String val = '';

  @override
  void initState() {
    debugPrint('sepehr init State');
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      ref.read(proGiaEntratoProvider.notifier).state = true;
      debugPrint('updated list sepehr');
      pwdFiltered = filterListOfPwd('', ref.watch(proPwdListProvider).value!);
      // for (var element in pwdFiltered) {
      //   debugPrint('${element.toString()}   sepehr');
      // }
      //ref.read(proArgsProvider.notifier).state = 'pass';
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final psList = ref.watch(proPwdListProvider);
    pwdFiltered = filterListOfPwd(val, ref.watch(proPwdListProvider).value!);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
          ? const NotePassFloatingActionBtn()
          : Container(),
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.white)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: (() =>
                    showMyDialog(context, ShowDialogCase.export, ref)),
                child: Text(exportBtnStr),
              ),
            ),
          ),
        ],
        title: Text(Txt.getTxtTestata("pass")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: searchField(
                fun: (value) {
                  val = value;
                  pwdFiltered = filterListOfPwd(value, psList.value!);
                  setState(() {});
                  //pwdFilterd.clear();
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      ...pwdFiltered.map(
                        (e) => UnPassword(
                          initVal: e.pwdCorpo,
                          hint: e.pwdHint,
                          id: e.pwdId,
                          used: e.flagUsed,
                          fun: () {
                            ref.invalidate(proPwdListProvider);
                          },
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  List<Pwd> filterListOfPwd(String needle, List<Pwd> lPwd) {
    List<Pwd> tmp = [];
    if (needle != '') {
      for (var element in lPwd) {
        if (element.pwdHint.contains(needle)) {
          tmp.add(element);
        }
      }
      if (tmp.isNotEmpty) {
        return tmp;
      } else {
        return [];
      }
    } else {
      return lPwd;
    }
  }
}
