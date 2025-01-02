import 'package:flutter/material.dart';

class BAFButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const BAFButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ));
  }
}
