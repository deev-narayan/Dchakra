import 'package:dchakra/models/chakra.dart';
import 'package:dchakra/pages/practice/mantra_session_page.dart';
import 'package:dchakra/pages/practice/yoga_session_page.dart';
import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/utils/chakra_colors.dart';
import 'package:dchakra/utils/responsive.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/chakra_spectrum.dart';
import 'package:dchakra/widgets/page_nav_button.dart';
import 'package:dchakra/widgets/soft_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Detail screen for one chakra (info + actions).
class ChakraDetailPage extends StatelessWidget {
  final Chakra chakra;

  const ChakraDetailPage({super.key, required this.chakra});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleService.instance.language,
      builder: (context, _, __) {
        final l = LocaleService.instance;
        final theme = Theme.of(context);
        final color = chakraColor(chakra.color);
        final r = Responsive.of(context);

        final title = Column(
          crossAxisAlignment:
              r.isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              chakra.name,
              textAlign: r.isWide ? TextAlign.start : TextAlign.center,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            const ChakraSpectrumBar(thickness: 4, length: 72),
          ],
        );

        final heroBlock = Column(
          crossAxisAlignment:
              r.isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _ChakraHalo(chakra: chakra, color: color, radius: r.heroRadius),
            SizedBox(height: r.sectionGap * 0.7),
            title,
          ],
        );

        final info = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SoftCard(
              accent: color,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Column(
                children: [
                  _InfoRow(
                    label: l.t('label_element'),
                    value: chakra.element,
                    color: color,
                    labelWidth: r.labelWidth,
                  ),
                  _rowDivider(theme),
                  _InfoRow(
                    label: l.t('label_location'),
                    value: chakra.location,
                    color: color,
                    labelWidth: r.labelWidth,
                  ),
                  _rowDivider(theme),
                  _InfoRow(
                    label: l.t('label_function'),
                    value: chakra.function,
                    color: color,
                    labelWidth: r.labelWidth,
                  ),
                  _rowDivider(theme),
                  _InfoRow(
                    label: l.t('label_mantra'),
                    value: chakra.mantra,
                    color: color,
                    labelWidth: r.labelWidth,
                  ),
                  _rowDivider(theme),
                  _InfoRow(
                    label: l.t('label_color'),
                    value: l.colorLabel(chakra.color),
                    color: color,
                    labelWidth: r.labelWidth,
                  ),
                ],
              ),
            ),
            SizedBox(height: r.sectionGap),
            if (r.isWide)
              Row(
                children: [
                  Expanded(
                    child: PageNavButton(
                      label: l.t('btn_yogasana'),
                      color: color,
                      filled: false,
                      icon: Icons.sports_gymnastics,
                      page: YogaSessionPage(
                        name: chakra.name,
                        color: chakra.color,
                        yogasana: chakra.yogasanaMap,
                      ),
                    ),
                  ),
                  SizedBox(width: r.itemGap),
                  Expanded(
                    child: PageNavButton(
                      label: l.t('btn_meditate'),
                      color: color,
                      icon: Icons.self_improvement,
                      page: MantraSessionPage(
                        chakraName: chakra.name,
                        accentColor: color,
                        audioUrl: chakra.music,
                        lottieAsset: chakra.lottie,
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              PageNavButton(
                label: l.t('btn_yogasana'),
                color: color,
                filled: false,
                icon: Icons.sports_gymnastics,
                page: YogaSessionPage(
                  name: chakra.name,
                  color: chakra.color,
                  yogasana: chakra.yogasanaMap,
                ),
              ),
              SizedBox(height: r.itemGap),
              PageNavButton(
                label: l.t('btn_meditate'),
                color: color,
                icon: Icons.self_improvement,
                page: MantraSessionPage(
                  chakraName: chakra.name,
                  accentColor: color,
                  audioUrl: chakra.music,
                  lottieAsset: chakra.lottie,
                ),
              ),
            ],
            SizedBox(height: r.itemGap),
            Text(
              l.t('detail_hint'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(),
          body: AmbientBackground(
            tint: color,
            child: ResponsiveBody(
              scrollable: true,
              child: r.isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: r.sectionGap),
                          child: heroBlock,
                        ),
                        Expanded(child: info),
                      ],
                    )
                  : Column(
                      children: [
                        heroBlock,
                        SizedBox(height: r.sectionGap),
                        info,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  static Widget _rowDivider(ThemeData theme) => Divider(
        height: 1,
        thickness: 1,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
      );
}

/// A chakra's mandala symbol inside a soft radial halo of its own hue.
class _ChakraHalo extends StatelessWidget {
  final Chakra chakra;
  final Color color;
  final double radius;

  const _ChakraHalo({
    required this.chakra,
    required this.color,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;

    Widget symbol;
    if (chakra.image.isEmpty) {
      symbol = Icon(Icons.spa, color: color, size: radius);
    } else if (chakra.image.endsWith('.svg')) {
      symbol = SvgPicture.asset(
        chakra.image,
        width: diameter * 0.72,
        height: diameter * 0.72,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      symbol = Image.asset(
        chakra.image,
        width: diameter * 0.78,
        height: diameter * 0.78,
      );
    }

    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.26),
            color.withValues(alpha: 0.05),
          ],
          stops: const [0.45, 1.0],
        ),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 1.5),
      ),
      child: symbol,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double labelWidth;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.color,
    required this.labelWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = Responsive.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.isCompact ? 12 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
