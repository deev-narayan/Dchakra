import 'package:flutter/material.dart';

Widget botmNavBar(BuildContext context) {
  final theme = Theme.of(context);
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Ensure visibility
        
      ),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home_rounded, color: theme.iconTheme.color),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.calendar_month_rounded,
                    color: theme.iconTheme.color),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings, color: theme.iconTheme.color),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, color: theme.iconTheme.color),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
