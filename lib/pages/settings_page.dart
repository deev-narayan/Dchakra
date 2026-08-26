import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/services/tts_service.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/soft_card.dart';
import 'package:flutter/material.dart';

/// Settings tab — language updates [LocaleService] (TTS + data JSON + UI).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;

  LocaleService get _locale => LocaleService.instance;
  TtsService get _tts => TtsService.instance;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _locale.language,
      builder: (context, _, __) {
        final l = _locale;
        return Scaffold(
          appBar: AppBar(title: Text(l.t('settings_title'))),
          body: AmbientBackground(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_outlined),
                        title: Text(l.t('notifications')),
                        subtitle: Text(l.t('notifications_sub')),
                        value: notifications,
                        onChanged: (v) => setState(() => notifications = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      SwitchListTile(
                        secondary: const Icon(Icons.volume_up_outlined),
                        title: Text(l.t('sound')),
                        subtitle: Text(l.t('sound_sub')),
                        value: _tts.soundEnabled,
                        onChanged: (v) => setState(() => _tts.soundEnabled = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l.t('language')),
                        subtitle: Text(l.label),
                        onTap: () async {
                          final selected = await showDialog<String>(
                            context: context,
                            builder: (context) => SimpleDialog(
                              title: Text(l.t('select_language')),
                              children: LocaleService.languageLabels.map((lang) {
                                return SimpleDialogOption(
                                  onPressed: () => Navigator.pop(context, lang),
                                  child: Text(lang),
                                );
                              }).toList(),
                            ),
                          );
                          if (selected == null || selected == l.label) return;
                          await l.setLanguage(selected);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l.t('about_title')),
                    subtitle: Text(l.t('about_sub')),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Dchakra',
                        applicationVersion: '1.0.0',
                        applicationLegalese: l.t('about_legalese'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
