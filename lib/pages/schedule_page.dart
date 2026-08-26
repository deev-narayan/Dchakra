import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/utils/chakra_colors.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/soft_card.dart';
import 'package:dchakra/widgets/stat_tile.dart';
import 'package:flutter/material.dart';

/// Schedule / streak tracker tab (mock data — swap for real persistence later).
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  static const int _streak = 12;
  static const Set<int> _completedDays = {
    1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 15, 16,
  };
  static const Set<int> _freezeDays = {4, 11};

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleService.instance.language,
      builder: (context, _, __) {
        final l = LocaleService.instance;
        final theme = Theme.of(context);
        final now = DateTime.now();
        final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
        final firstOffset = DateUtils.firstDayOffset(
          now.year,
          now.month,
          MaterialLocalizations.of(context),
        );
        final monthLabel =
            MaterialLocalizations.of(context).formatMonthYear(now);
        final weekdays = [
          l.t('weekday_m'),
          l.t('weekday_t'),
          l.t('weekday_w'),
          l.t('weekday_th'),
          l.t('weekday_f'),
          l.t('weekday_sa'),
          l.t('weekday_su'),
        ];

        return Scaffold(
          appBar: AppBar(title: Text(l.t('schedule_title'))),
          body: AmbientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Text(
                  l.t('day_streak', {'n': '$_streak'}),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l.t('schedule_mock_hint'),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 22),
                SoftCard(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(monthLabel, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: weekdays
                            .map(
                              (d) => Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: daysInMonth + firstOffset,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                        itemBuilder: (context, index) {
                          if (index < firstOffset) {
                            return const SizedBox.shrink();
                          }
                          final day = index - firstOffset + 1;
                          final done = _completedDays.contains(day);
                          final freeze = _freezeDays.contains(day);
                          final today = day == now.day;
                          // Completed days glow in their spectrum hue.
                          final doneColor =
                              kChakraSpectrum[(day - 1) % kChakraSpectrum.length];

                          Color? bg;
                          if (done) {
                            bg = doneColor;
                          } else if (freeze) {
                            bg = kVishuddha.withValues(alpha: 0.22);
                          }

                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: bg,
                              shape: BoxShape.circle,
                              border: today && !done
                                  ? Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 1.5,
                                    )
                                  : null,
                            ),
                            child: done
                                ? const Icon(Icons.check,
                                    size: 15, color: Colors.white)
                                : Text(
                                    '$day',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StatTile(
                  icon: Icons.ac_unit,
                  color: kVishuddha,
                  label: l.t('freeze_streak'),
                  value: l.t('left_count', {'n': '2'}),
                ),
                const SizedBox(height: 12),
                StatTile(
                  icon: Icons.bolt,
                  color: kManipura,
                  label: l.t('total_xp'),
                  value: '450',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
