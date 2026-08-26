import 'package:dchakra/models/chakra.dart';
import 'package:dchakra/pages/chakra_detail_page.dart';
import 'package:dchakra/services/chakra_data_service.dart';
import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/utils/chakra_colors.dart';
import 'package:dchakra/utils/responsive.dart';
import 'package:dchakra/widgets/soft_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads chakra JSON for the current language and shows a responsive list/grid.
class ChakraListView extends StatefulWidget {
  const ChakraListView({super.key});

  @override
  State<ChakraListView> createState() => _ChakraListViewState();
}

class _ChakraListViewState extends State<ChakraListView> {
  late Future<List<Chakra>> _future;

  @override
  void initState() {
    super.initState();
    _future = ChakraDataService.instance.load();
    LocaleService.instance.language.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LocaleService.instance.language.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {
      _future = ChakraDataService.instance.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return FutureBuilder<List<Chakra>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              LocaleService.instance.t('load_failed', {
                'error': '${snapshot.error}',
              }),
            ),
          );
        }
        final chakras = snapshot.data ?? const [];
        if (chakras.isEmpty) {
          return Center(child: Text(LocaleService.instance.t('no_chakras')));
        }

        if (r.chakraColumns > 1) {
          return GridView.builder(
            padding: EdgeInsets.only(top: r.itemGap, bottom: r.sectionGap),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: r.chakraColumns,
              mainAxisSpacing: r.itemGap + 4,
              crossAxisSpacing: r.itemGap + 4,
              childAspectRatio: 3.1,
            ),
            itemCount: chakras.length,
            itemBuilder: (context, index) {
              return ChakraCard(chakra: chakras[index], index: index);
            },
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: r.itemGap, bottom: r.sectionGap),
          itemCount: chakras.length,
          separatorBuilder: (_, __) => SizedBox(height: r.itemGap + 4),
          itemBuilder: (context, index) {
            return ChakraCard(chakra: chakras[index], index: index);
          },
        );
      },
    );
  }
}

/// One chakra entry in the home list/grid — a soft card led by a color-ringed
/// mandala node and an edge accent in that chakra's hue.
class ChakraCard extends StatelessWidget {
  final Chakra chakra;
  final int index;

  const ChakraCard({super.key, required this.chakra, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = chakraColor(chakra.color);

    return SoftCard(
      padding: EdgeInsets.zero,
      accent: color,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChakraDetailPage(chakra: chakra)),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Edge accent — this chakra's position in the spectrum.
            Container(width: 5, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Row(
                  children: [
                    _MandalaNode(chakra: chakra, color: color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chakra.name,
                            style: theme.textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${chakra.element}  ·  ${chakra.mantra}',
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: color.withValues(alpha: 0.8),
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
}

/// Circular, color-ringed holder for a chakra's mandala symbol.
class _MandalaNode extends StatelessWidget {
  final Chakra chakra;
  final Color color;
  final double size;

  const _MandalaNode({
    required this.chakra,
    required this.color,
    this.size = 54,
  });

  @override
  Widget build(BuildContext context) {
    Widget symbol;
    if (chakra.image.isEmpty) {
      symbol = Icon(Icons.spa, color: color, size: size * 0.5);
    } else if (chakra.image.endsWith('.svg')) {
      symbol = SvgPicture.asset(
        chakra.image,
        width: size * 0.82,
        height: size * 0.82,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      symbol = Image.asset(
        chakra.image,
        width: size * 0.72,
        height: size * 0.72,
      );
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.38), width: 1.2),
      ),
      child: symbol,
    );
  }
}
