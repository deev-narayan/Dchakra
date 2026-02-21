import 'dart:convert';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dchakra/icons/logo.dart';
import 'dart:developer' as developer;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

String jsonPath = "assets/data/list_chakra_details.json";

class ContainList extends StatefulWidget {
  const ContainList({super.key});

  @override
  State<ContainList> createState() => _ContainListState();
}

class _ContainListState extends State<ContainList> {
  List<dynamic> chakraData = [];

  @override
  void initState() {
    super.initState();
    loadChakraData();
  }

  Future<void> loadChakraData() async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        chakraData = data;
      });
    } catch (e) {
      developer.log('Error loading JSON: $e'); // Log any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chakraData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: chakraData.length,
        itemBuilder: (context, index) {
          final item = chakraData[index];
          Map<String, Map<String, dynamic>> yogasanaMap = {};
          if (item['yogasana'] != null &&
              item['yogasana'] is Map<String, dynamic>) {
            try {
              Map<String, dynamic> rawYogasana = item['yogasana'];
              yogasanaMap = rawYogasana.cast<String, Map<String, dynamic>>();
            } catch (e) {
              developer.log('Error casting yogasana for ${item['name']}: $e');
            }
          }

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ChakraList(
                  name: item['name'] as String? ?? 'Unknown',
                  image: item['image'] as String? ?? '',
                  color: item['color'] as String? ?? '',
                  element: item['element'] as String? ?? '',
                  location: item['location'] as String? ?? '',
                  function: item['function'] as String? ?? '',
                  mantra: item['mantra'] as String? ?? '',
                  music: item['music'] as String? ?? '',
                  yogasana: yogasanaMap,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



class ChakraList extends StatelessWidget {
  final String name;
  final String image;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;
  final String music;
  final Map<String, Map<String, dynamic>> yogasana;

  const ChakraList({
    super.key,
    required this.name,
    required this.image,
    required this.color,
    required this.element,
    required this.location,
    required this.function,
    required this.mantra,
    required this.yogasana, required this.music,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chakraColor = getChakraColor(color);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: GlassEffect(
          radius: 24,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ItemDetailInfo(
                      name: name,
                      image: image,
                      color: color,
                      element: element,
                      location: location,
                      function: function,
                      mantra: mantra,
                      yogasana: yogasana,
                      music: music,
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 1.5,
                  color: chakraColor.withOpacity(0.3),
                ),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          chakraColor.withOpacity(0.15),
                          Colors.black.withOpacity(0.6),
                        ]
                      : [
                          chakraColor.withOpacity(0.1),
                          Colors.white.withOpacity(0.8),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: chakraColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: name,
                    child: Container(
                      padding: const EdgeInsets.all(4),
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
                        boxShadow: [
                          BoxShadow(
                            color: chakraColor.withOpacity(0.6),
                            blurRadius: 18,
                            spreadRadius: 3,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.scaffoldBackgroundColor,
                        backgroundImage: AssetImage(image),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.titleLarge?.color,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.spa_outlined,
                              size: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                element,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: chakraColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: chakraColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            constraints: const BoxConstraints(maxWidth: 140),
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