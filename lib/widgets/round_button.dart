import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool loader;

  const RoundButton(
      {Key? key, required this.title, required this.onTap, this.loader = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: Center(
          child: loader
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
