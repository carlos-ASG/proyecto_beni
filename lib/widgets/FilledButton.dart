import 'package:flutter/material.dart';

class FilltedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;

  const FilltedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
    );
  }
}
