import 'package:dchakra/notifiers.dart';
import 'package:dchakra/pages/level_documentation.dart';
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
        color: theme.scaffoldBackgroundColor,
      ),
      child: Container(
        child: ValueListenableBuilder<int>(
          valueListenable: selectedIndexNotifier,
          builder: (context, selectedIndex, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_rounded,
                  index: 0,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    selectedIndexNotifier.value = 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LevelDocumentation()),
                    );
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.calendar_month_rounded,
                  index: 1,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    selectedIndexNotifier.value = 1;
                    // TODO: Navigate to Calendar
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings,
                  index: 2,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    selectedIndexNotifier.value = 2;
                    // TODO: Navigate to Settings
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person,
                  index: 3,
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    selectedIndexNotifier.value = 3;
                    // TODO: Navigate to Profile
                  },
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildNavItem({
  required BuildContext context,
  required IconData icon,
  required int index,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final color = isSelected 
      ? (theme.brightness == Brightness.dark ? const Color(0xFFE94E77) : const Color(0xFF6750A4)) 
      : theme.iconTheme.color?.withOpacity(0.5);

  return IconButton(
    onPressed: onTap,
    icon: Icon(
      icon, 
      color: color,
      size: isSelected ? 30 : 24, // Slight scale effect
    ),
  );
}
