import 'package:flutter/material.dart';

import '../models/data.dart';
import '../widgets/layout.dart';
import 'category_screen.dart';
import 'settings_screen.dart';

/// Дэлгэрэнгүй дэлгэцүүд Navigator stack-д орно — "Буцах" дархад
/// өмнөх дэлгэц гүйлгэлтийн байрлалтайгаа хамт сэргэнэ.
void openSkill(BuildContext context, Skill skill) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryScreen(skillId: skill.id)));
}

void openSettings(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
}

/// Дэлгэрэнгүй дэлгэцийн нийтлэг хүрээ.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: PageBody(bottomPadding: 32, children: children)),
      ),
    );
  }
}
