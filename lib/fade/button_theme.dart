import 'package:flutter/material.dart';

class BtnTheme extends StatelessWidget {
  final Widget child;
  final String text;
  final Color color;
  const BtnTheme({super.key, required this.child, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return child;
            },
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        side: BorderSide(
          color: color,
          width: 1,
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              const Color.fromARGB(66, 0, 0, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          height: 50,
          width: 130,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(190, 255, 255, 255),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
