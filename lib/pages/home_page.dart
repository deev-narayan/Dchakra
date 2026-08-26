import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/utils/responsive.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/chakra_list_view.dart';
import 'package:dchakra/widgets/section_header.dart';
import 'package:flutter/material.dart';

/// Home tab — brand wordmark, a display heading, and the seven chakra levels.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleService.instance.language,
      builder: (context, _, __) {
        final theme = Theme.of(context);
        final r = Responsive.of(context);
        final hPad = r.isCompact ? 16.0 : (r.isWide ? 40.0 : 28.0);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Dchakra',
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                letterSpacing: 3,
              ),
            ),
          ),
          body: AmbientBackground(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    SectionHeader(
                      title: LocaleService.instance.t('home_title'),
                    ),
                    const Expanded(child: ChakraListView()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
