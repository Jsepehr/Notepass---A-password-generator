import 'package:flutter/material.dart';

import '../../utility/utility_functions.dart';

class NotePassFloatingActionBtn extends StatelessWidget {
  final String strVar;
  const NotePassFloatingActionBtn({
    required this.strVar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 2,
      backgroundColor: Colors.blue[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil("/", (_) {
          return false;
        }, arguments: Args(null, null, strVar));
      },
      child: const Icon(
        Icons.home,
        color: Colors.blue,
      ),
    );
  }
}
