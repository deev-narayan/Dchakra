import 'package:dchakra/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // Mock Data for the Tracker
  final int _currentStreak = 12;
  final Set<int> _completedDays = {1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 15, 16}; // Days of current month
  final Set<int> _freezeDays = {4, 11}; // Days where streak freeze was used
  
  // Current Month State
  final DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calendar Calculations
    final daysInMonth = DateUtils.getDaysInMonth(_focusedDate.year, _focusedDate.month);
    final firstDayOffset = DateUtils.firstDayOffset(_focusedDate.year, _focusedDate.month, MaterialLocalizations.of(context));
    
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Background (Solid or Subtle Gradient)
          Container(
            height: double.infinity,
            width: double.infinity,
             decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                  ? [const Color(0xFF181920), const Color(0xFF2D2E36)] 
                  : [const Color(0xFFF7F7F7), const Color(0xFFFFFFFF)],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // --- Top Bar / Header ---
                _buildTopBar(theme),

                Expanded(
                  child: AnimationLimiter(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 40.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            
                            // --- Streak Hero Section ---
                            _buildStreakHero(theme, screenWidth),
                            
                            SizedBox(height: screenHeight * 0.03),

                            // --- Calendar Card ---
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                                border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Month Header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.chevron_left_rounded, color: theme.iconTheme.color),
                                      ),
                                      Text(
                                        "February 2026", // Dynamic in real app
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: theme.textTheme.titleLarge?.color,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.chevron_right_rounded, color: theme.iconTheme.color),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  
                                  // Days of Week Headers
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: ["M", "T", "W", "T", "F", "S", "S"].map((day) => 
                                      SizedBox(
                                        width: (screenWidth * 0.08).clamp(24.0, 40.0),
                                        child: Center(
                                          child: Text(
                                            day,
                                            style: GoogleFonts.outfit(
                                              fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
                                              fontWeight: FontWeight.bold,
                                              color: theme.disabledColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ).toList(),
                                  ),
                                  
                                  const SizedBox(height: 10),

                                  // Calendar Grid
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: daysInMonth + firstDayOffset, 
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 5,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index < firstDayOffset) {
                                        return const SizedBox();
                                      }
                                      final day = index - firstDayOffset + 1;
                                      return _buildCalendarDay(theme, day);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // --- Stats / Info Cards ---
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard(
                                      theme, 
                                      title: "Freeze Streak",
                                      value: "2 Left",
                                      icon: Icons.ac_unit_rounded,
                                      color: Colors.blueAccent,
                                      screenWidth: screenWidth,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: _buildInfoCard(
                                      theme, 
                                      title: "Total XP",
                                      value: "450 XP",
                                      icon: Icons.flash_on_rounded,
                                      color: Colors.amber,
                                      screenWidth: screenWidth,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.15), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          botmNavBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Progress Tracker",
            style: GoogleFonts.cinzel(
              fontSize: (screenWidth * 0.06).clamp(18.0, 32.0),
              fontWeight: FontWeight.bold,
              color: theme.textTheme.displayLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakHero(ThemeData theme, double screenWidth) {
    final fireIconSize = (screenWidth * 0.2).clamp(60.0, 100.0);
    return Column(
      children: [
        // 3D-ish Fire Icon / Image
        Container(
          height: fireIconSize * 1.5,
          width: fireIconSize * 1.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ]
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            size: fireIconSize,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "$_currentStreak Day Streak!",
          style: GoogleFonts.outfit(
            fontSize: (screenWidth * 0.08).clamp(24.0, 40.0),
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Text(
          "You're on fire! Keep it up.",
          style: GoogleFonts.outfit(
            fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarDay(ThemeData theme, int day) {
    bool isCompleted = _completedDays.contains(day);
    bool isFreeze = _freezeDays.contains(day);
    bool isToday = day == DateTime.now().day; 

    Color bgColor = theme.cardColor;
    Color textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    BoxBorder? border;

    if (isCompleted) {
      bgColor = Colors.orange;
      textColor = Colors.white;
    } else if (isFreeze) {
      bgColor = Colors.blueAccent.withOpacity(0.3);
      textColor = Colors.blueAccent;
    } else if (isToday) {
      border = Border.all(color: Colors.orange, width: 2);
    } else {
      bgColor = theme.disabledColor.withOpacity(0.1);
      textColor = theme.disabledColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
        boxShadow: isCompleted ? [
           BoxShadow(
             color: Colors.orange.withOpacity(0.4),
             blurRadius: 5,
             offset: const Offset(0, 3)
           )
        ] : [],
      ),
      child: Center(
        child: isCompleted 
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
            : isFreeze 
                ? const Icon(Icons.ac_unit_rounded, color: Colors.blueAccent, size: 16)
                : Text(
                    "$day",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, {required String title, required String value, required IconData icon, required Color color, required double screenWidth}) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.05),
             blurRadius: 10,
             offset: const Offset(0, 5)
           )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: (screenWidth * 0.05).clamp(16.0, 24.0),
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
} // End of Class