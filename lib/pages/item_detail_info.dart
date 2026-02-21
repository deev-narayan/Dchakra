import 'package:dchakra/fade/button_theme.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/yoga&meditaton/balance_menu.dart';
import 'package:dchakra/pages/yoga&meditaton/mantra_chant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color getChakraColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red': // Root Chakra
      return const Color.fromARGB(255, 183, 28, 28); // Deep Red
    case 'orange': // Sacral Chakra
      return const Color.fromARGB(255, 255, 87, 34); // Bright Orange
    case 'yellow': // Solar Plexus Chakra
      return const Color.fromARGB(255, 255, 193, 7); // Sunny Yellow
    case 'green': // Heart Chakra
      return const Color.fromARGB(255, 76, 175, 80); // Vibrant Green
    case 'blue': // Throat Chakra
      return const Color.fromARGB(255, 33, 150, 243); // Calm Blue
    case 'indigo': // Third Eye Chakra
      return const Color.fromARGB(255, 63, 81, 181); // Deep Indigo
    case 'violet': // Crown Chakra
      return const Color.fromARGB(255, 156, 39, 176); // Elegant Violet
    default:
      return Colors.grey; // fallback neutral color
  }
}

class ItemDetailInfo extends StatelessWidget {
  final String name;
  final String image;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;
  final Map<String, Map<String, dynamic>> yogasana;

  const ItemDetailInfo({
    super.key,
    required this.name,
    required this.image,
    required this.color,
    required this.element,
    required this.location,
    required this.function,
    required this.mantra,
    required this.yogasana,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chakraColor = getChakraColor(color);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final titleFontSize = (screenWidth * 0.06).clamp(18.0, 26.0);
    final subtitleFontSize = (screenWidth * 0.035).clamp(12.0, 16.0);
    final heroImageSize = (screenWidth * 0.55).clamp(180.0, 300.0);
    final cardPadding = (screenWidth * 0.045).clamp(12.0, 24.0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: LinrGrage()),
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: chakraColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const BackButton(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$element • $location',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: subtitleFontSize,
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              chakraColor.withOpacity(0.9),
                              chakraColor.withOpacity(0.4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.spa_rounded,
                          size: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, screenHeight * 0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  chakraColor.withOpacity(0.95),
                                  chakraColor.withOpacity(0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: chakraColor.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 6,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: name,
                              child: ClipOval(
                                child: Image.asset(
                                  image,
                                  height: heroImageSize,
                                  width: heroImageSize,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            if (element.isNotEmpty)
                              _InfoChip(
                                icon: Icons.spa_outlined,
                                label: element,
                                color: chakraColor,
                              ),
                            if (location.isNotEmpty)
                              _InfoChip(
                                icon: Icons.place_rounded,
                                label: location,
                                color: chakraColor,
                              ),
                            if (mantra.isNotEmpty)
                              _InfoChip(
                                icon: Icons.self_improvement_rounded,
                                label: mantra,
                                color: chakraColor,
                              ),
                            _InfoChip(
                              icon: Icons.palette_rounded,
                              label: color,
                              color: chakraColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(cardPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: theme.cardColor.withOpacity(0.96),
                            boxShadow: [
                              BoxShadow(
                                color: chakraColor.withOpacity(0.16),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About $name',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Key properties and how this chakra influences your energy body.',
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                context,
                                "Element",
                                element,
                                chakraColor,
                              ),
                              _buildInfoRow(
                                context,
                                "Location",
                                location,
                                chakraColor,
                              ),
                              _buildInfoRow(
                                context,
                                "Function",
                                function,
                                chakraColor,
                              ),
                              _buildInfoRow(
                                context,
                                "Mantra",
                                mantra,
                                chakraColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: (screenHeight * 0.04).clamp(10.0, 40.0),
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: BtnTheme(
                        text: "Yogasana",
                        color: chakraColor,
                        child: BalanceMenu(
                          yogasana: yogasana,
                          name: name,
                          color: color,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: BtnTheme(
                        text: "Meditate",
                        color: chakraColor,
                        child: MantraChant(
                          chakraName: name,
                          getClr: chakraColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    Color accentColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: accentColor.withOpacity(0.06),
        border: Border.all(
          color: accentColor.withOpacity(0.35),
          width: 0.9,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.9),
                  accentColor.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color:
                        textTheme.bodyMedium?.color ?? Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    height: 1.4,
                    color:
                        textTheme.bodyMedium?.color ?? Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(0.08),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
