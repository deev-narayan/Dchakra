import 'package:dchakra/config/theme.dart';
import 'package:dchakra/pages/main_shell.dart';
import 'package:dchakra/services/locale_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleService.instance.init();
  runApp(const DchakraApp());
}

class DchakraApp extends StatelessWidget {
  const DchakraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dchakra',
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}
