import 'package:flutter/material.dart';

class NotePassFloatingActionBtn extends StatelessWidget {
  const NotePassFloatingActionBtn({
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
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/",
          (_) {
            return false;
          },
        );
      },
      child: const Icon(
        Icons.home,
        color: Colors.blue,
      ),
    );
  }
}
