import 'package:dchakra/navbar.dart';
import 'package:dchakra/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Ensure this is in pubspec or use standard animations if not
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Mock State Variables
  bool _notificationsEnabled = true;
  bool _darkMode = false; // In a real app, bind this to ThemeProvider
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Sync local state regarding theme for visualization purposes
    // _darkMode = isDark; 

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Settings",
                        style: GoogleFonts.cinzel( // Using standard font from welcome page
                          fontSize: (screenWidth * 0.08).clamp(24.0, 40.0),
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.displayLarge?.color,
                        ),
                      ),
                      // Optional: Sync icon or similar
                    ],
                  ),
                ),

                Expanded(
                  child: AnimationLimiter(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          _buildSectionHeader(theme, "General", screenWidth),
                          _buildSwitchTile(
                            theme,
                            icon: Icons.notifications_outlined,
                            title: "Notifications",
                            subtitle: "Enable push notifications",
                            value: _notificationsEnabled,
                            onChanged: (v) => setState(() => _notificationsEnabled = v),
                            screenWidth: screenWidth,
                          ),
                          _buildSwitchTile(
                            theme,
                            icon: Icons.dark_mode_outlined,
                            title: "Dark Mode",
                            subtitle: "Adjust app appearance",
                            value: _darkMode, // This would ideally toggle the actual theme
                            onChanged: (v) {
                               setState(() => _darkMode = v);
                               // Setup theme toggle logic here if managed globally
                            },
                            screenWidth: screenWidth,
                          ),
                          _buildSwitchTile(
                            theme,
                            icon: Icons.volume_up_outlined,
                            title: "Sound & Haptics",
                            subtitle: "Enable sound effects",
                            value: _soundEnabled,
                            onChanged: (v) => setState(() => _soundEnabled = v),
                            screenWidth: screenWidth,
                          ),

                          SizedBox(height: screenHeight * 0.02),
                          _buildSectionHeader(theme, "Account", screenWidth),
                          _buildNavTile(
                            theme, 
                            icon: Icons.person_outline, 
                            title: "Account Details",
                            onTap: () {
                              // Navigate to personal details
                            },
                            screenWidth: screenWidth,
                          ),
                          _buildNavTile(
                            theme, 
                            icon: Icons.privacy_tip_outlined, 
                            title: "Privacy Policy",
                           onTap: () {
                              // Open privacy policy
                            },
                            screenWidth: screenWidth,
                          ),
                          
                          SizedBox(height: screenHeight * 0.02),
                          _buildSectionHeader(theme, "Support", screenWidth),
                          _buildNavTile(
                            theme, 
                            icon: Icons.help_outline, 
                            title: "Help & Feedback",
                            onTap: () {},
                            screenWidth: screenWidth,
                          ),
                          _buildNavTile(
                            theme, 
                            icon: Icons.info_outline, 
                            title: "About Dchakra",
                            onTap: () {},
                            screenWidth: screenWidth,
                          ),

                          SizedBox(height: screenHeight * 0.05),
                          
                          // Sign Out Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.error.withOpacity(0.8),
                                    theme.colorScheme.error.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.error.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Handle sign out
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: Text(
                                        "Sign Out",
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Bottom Padding for Navbar
                          SizedBox(height: screenHeight * 0.12),
                        ],
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

  Widget _buildSectionHeader(ThemeData theme, String title, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10, top: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          color: theme.colorScheme.primary.withOpacity(0.8),
          fontSize: (screenWidth * 0.032).clamp(11.0, 15.0),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double screenWidth,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5), // Glassmorphism-ish
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: SwitchListTile(
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: theme.colorScheme.primary, size: 22),
        ),
        title: Text(
          title, 
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
          ),
        ),
        subtitle: Text(
          subtitle, 
          style: GoogleFonts.outfit(
            fontSize: (screenWidth * 0.032).clamp(11.0, 15.0),
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
          child: Icon(icon, color: theme.colorScheme.secondary, size: 22),
        ),
        title: Text(
          title, 
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded, 
          size: 16, 
          color: theme.disabledColor,
        ),
      ),
    );
  }
}