import 'package:flutter/material.dart';

class BtnTheme extends StatelessWidget {
  final Widget child;
  final String text;
  final Color color;
  const BtnTheme(
      {super.key,
      required this.child,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return child;
            },
          ),
        );
      },
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color, width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white, // Keep white for contrast on gradient
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
