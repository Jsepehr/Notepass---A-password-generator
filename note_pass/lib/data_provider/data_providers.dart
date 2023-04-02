import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_pass/utility/db_helper.dart';
import 'package:note_pass/utility/utility_functions.dart';

import '../model/pwd.dart';

final proPwdListProvider = FutureProvider<List<Pwd>>((ref) async {
  List<Pwd> lp = [];
  final data = await DBhelper.getData();
  for (var element in data) {
    lp.add(Pwd.fromMap(element));
  }
  debugPrint('chiamata sepehr pro pwd list');
  return lp;
});

final proGiaEntratoProvider = StateProvider<bool>((ref) {
  return false;
});

final proCreatePwdProvider = Provider<CreatePasswords>((ref) {
  return CreatePasswords();
});

final proStrHashProvider = Provider.family<String?, String>((ref, str) {
  return generateStringHash(str);
});
final proImgHashProvider =
    FutureProvider.family<String, File>((ref, file) async {
  return await generateImageHash(file);
});

final proImgAndStrProvider = StateProvider<Map<String, String?>>((ref) {
  Map<String, String?> result = {};
  ref.listenSelf((previous, next) {
    result = next;
  });
  return result;
});
