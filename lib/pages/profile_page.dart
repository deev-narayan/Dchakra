import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/utils/chakra_colors.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/stat_tile.dart';
import 'package:flutter/material.dart';

/// Profile tab — local placeholder (no authentication).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleService.instance.language,
      builder: (context, _, __) {
        final l = LocaleService.instance;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(title: Text(l.t('profile_title'))),
          body: AmbientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                const SizedBox(height: 8),
                const Center(child: _SpectrumAvatar()),
                const SizedBox(height: 18),
                Text(
                  l.t('guest'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l.t('no_account'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                StatTile(
                  icon: Icons.local_fire_department,
                  color: kMuladhara,
                  label: l.t('streak'),
                  value: l.t('days_count', {'n': '5'}),
                ),
                const SizedBox(height: 12),
                StatTile(
                  icon: Icons.self_improvement,
                  color: kVishuddha,
                  label: l.t('meditations'),
                  value: '12',
                ),
                const SizedBox(height: 12),
                StatTile(
                  icon: Icons.timer_outlined,
                  color: kManipura,
                  label: l.t('practice_time'),
                  value: l.t('hours_count', {'n': '4.5'}),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Avatar framed by a sweeping ring of the seven chakra hues.
class _SpectrumAvatar extends StatelessWidget {
  const _SpectrumAvatar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 104,
      height: 104,
      padding: const EdgeInsets.all(3.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [...kChakraSpectrum, kMuladhara],
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surface,
        ),
        child: Icon(
          Icons.self_improvement,
          size: 48,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
