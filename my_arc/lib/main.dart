import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() {
  runApp(MyArcApp(state: AppState()));
}

class MyArcApp extends StatelessWidget {
  const MyArcApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    // AppScope нь MaterialApp-ийн дээр байгаа тул push хийсэн дэлгэцүүд ч төлөвөө харна.
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'MY ARC',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const AppShell(),
      ),
    );
  }
}
