import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
            color: Colors.white,
          ),
        ));
  }
}
