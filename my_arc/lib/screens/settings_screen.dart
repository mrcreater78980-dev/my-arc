import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/components.dart';
import '../widgets/layout.dart';
import 'navigation.dart';

class _SettingRow {
  final String id;
  final String title;
  final IconData icon;
  final String color;
  final String? value;
  const _SettingRow(this.id, this.title, this.icon, this.color, [this.value]);
}

const _rows = [
  _SettingRow('profile', 'Профайл', Icons.person_outline_rounded, 'blue', 'Бат'),
  _SettingRow('reminders', 'Сануулга', Icons.notifications_none_rounded, 'violet', '20:00'),
  _SettingRow('language', 'Хэл', Icons.language_rounded, 'teal', 'Монгол'),
  _SettingRow('export', 'Өгөгдөл хадгалах', Icons.download_rounded, 'blue'),
  _SettingRow('help', 'Тусламж', Icons.help_outline_rounded, 'violet'),
  _SettingRow('logout', 'Гарах', Icons.logout_rounded, 'neutral'),
];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      children: [
        const BackHeader(title: 'Тохиргоо'),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Overline('ТАНЫ ОРОН ЗАЙ, ТАНЫ ХЭМНЭЛ'),
        ),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (var i = 0; i < _rows.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 66, color: Color(0xFFE8EDF8)),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: IconBadge(icon: _rows[i].icon, color: _rows[i].color, size: 18),
                  title: Text(_rows[i].title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_rows[i].value != null)
                        Text(_rows[i].value!,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.muted)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.faint),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Column(
          children: [
            Icon(Icons.verified_user_outlined, size: 18, color: AppColors.faint),
            SizedBox(height: 8),
            Text(
              'Өөрийн өсөлтийн орон зайгаа\nөөрийнхөөрөө бүтээгээрэй.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.secondary, height: 1.5),
            ),
            SizedBox(height: 18),
            Text('Өдөр бүр, нэг алхам урагш.', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }
}
