import 'package:dchakra/pages/home_page.dart';
import 'package:dchakra/pages/profile_page.dart';
import 'package:dchakra/pages/schedule_page.dart';
import 'package:dchakra/pages/settings_page.dart';
import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/state/nav_index.dart';
import 'package:dchakra/utils/responsive.dart';
import 'package:dchakra/widgets/chakra_spectrum.dart';
import 'package:flutter/material.dart';

/// Root shell: bottom nav on small screens, side rail on large screens.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[
    HomePage(),
    SchedulePage(),
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocaleService.instance.language,
      builder: (context, _, __) {
        final l = LocaleService.instance;
        final r = Responsive.of(context);

        return ValueListenableBuilder<int>(
          valueListenable: navIndex,
          builder: (context, index, _) {
            final destinations = [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l.t('nav_home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month),
                label: l.t('nav_schedule'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: l.t('nav_settings'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l.t('nav_profile'),
              ),
            ];

            final body = IndexedStack(
              index: index,
              children: _pages,
            );

            if (r.useNavigationRail) {
              return Scaffold(
                body: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: index,
                      onDestinationSelected: (i) => navIndex.value = i,
                      leading: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: ChakraSpectrumBar(
                          axis: Axis.vertical,
                          length: 84,
                          thickness: 4,
                        ),
                      ),
                      extended: r.width >= 1100,
                      labelType: r.width >= 1100
                          ? NavigationRailLabelType.none
                          : NavigationRailLabelType.all,
                      destinations: [
                        for (final d in destinations)
                          NavigationRailDestination(
                            icon: d.icon,
                            selectedIcon: d.selectedIcon,
                            label: Text(d.label),
                          ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: body),
                  ],
                ),
              );
            }

            return Scaffold(
              body: body,
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ChakraSpectrumBar(thickness: 3),
                  NavigationBar(
                    selectedIndex: index,
                    onDestinationSelected: (i) => navIndex.value = i,
                    destinations: destinations,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
