import 'package:flutter/material.dart';

class BAFButton extends StatefulWidget {
  final Function()? onTap;
  final String text;

  const BAFButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  _BAFButtonState createState() => _BAFButtonState();
}

class _BAFButtonState extends State<BAFButton> {
  Color color = Colors.green[500]!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(widget.text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        ),
      ),
      onTapDown: (_) {
        // Change color to green[400] when button is pressed
        setState(() {
          color = Colors.green[300]!;
        });
      },
      onTapUp: (_) {
        // Change color back to green[500] when button is released
        setState(() {
          color = Colors.green[500]!;
        });
      },
      onTapCancel: () {
        // Change color back to green[500] when tap is cancelled
        setState(() {
          color = Colors.green[300]!;
        });
      },
    );
  }
}
