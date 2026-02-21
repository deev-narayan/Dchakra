import 'package:dchakra/navbar.dart';
import 'package:dchakra/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Premium Background Gradient
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

          // 2. Main Body
          SafeArea(
            child: AnimationLimiter(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      // Header Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: GoogleFonts.cinzel(
                                fontSize: (screenWidth * 0.08).clamp(24.0, 40.0),
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.displayLarge?.color,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Navigate to edit or settings
                              },
                              icon: Icon(Icons.edit_outlined, color: theme.iconTheme.color),
                            )
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.03),

                      // Avatar Section
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4), // Border width
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: (screenWidth * 0.15).clamp(40.0, 80.0),
                                backgroundColor: theme.scaffoldBackgroundColor,
                                backgroundImage: _user?.photoURL != null 
                                    ? NetworkImage(_user!.photoURL!) 
                                    : null,
                                child: _user?.photoURL == null
                                    ? Icon(Icons.person, size: (screenWidth * 0.15).clamp(40.0, 80.0), color: theme.disabledColor)
                                    : null,
                              ),
                            ),
                            // Status Indicator or Edit Icon
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                  )
                                ]
                              ),
                              child: Icon(Icons.camera_alt_outlined, size: 20, color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // User Info
                      Column(
                        children: [
                          Text(
                            _user?.displayName ?? "Guest User",
                            style: GoogleFonts.outfit(
                              fontSize: (screenWidth * 0.06).clamp(18.0, 28.0),
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _user?.email ?? "Sign in to sync progress",
                            style: GoogleFonts.outfit(
                              fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Stats Grid
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: (screenWidth / screenHeight * 3.5).clamp(1.2, 2.0),
                          children: [
                            _buildStatCard(theme, "Streak", "5 Days", Icons.local_fire_department_rounded, Colors.orange, screenWidth),
                            _buildStatCard(theme, "Meditations", "12", Icons.self_improvement_rounded, Colors.purple, screenWidth),
                            _buildStatCard(theme, "Time", "4.5 Hrs", Icons.timer_rounded, Colors.blue, screenWidth),
                            _buildStatCard(theme, "Level", "Adept", Icons.stars_rounded, Colors.amber, screenWidth),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Premium Upgrade Banner (Example)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6750A4),
                              const Color(0xFFE94E77),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE94E77).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.diamond_rounded, color: Colors.white, size: (screenWidth * 0.06).clamp(20.0, 32.0)),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Go Premium",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Unlock all meditations & stats",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.8), size: (screenWidth * 0.04).clamp(14.0, 18.0)),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.12), // Space for Navbar
                    ],
                  ),
                ),
              ),
            ),
          ),

          botmNavBar(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              // Tiny trend indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "+2%",
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: (screenWidth * 0.055).clamp(16.0, 24.0),
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: (screenWidth * 0.032).clamp(10.0, 14.0),
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}