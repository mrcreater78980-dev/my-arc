import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/components.dart';
import '../widgets/layout.dart';
import 'navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _editProfile(BuildContext context, AppState state) async {
    final controller = TextEditingController(text: state.profileName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нэрээ засах'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          maxLength: 32,
          decoration: const InputDecoration(labelText: 'Таны нэр'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Болих')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Хадгалах')),
        ],
      ),
    );
    controller.dispose();
    if (name != null) state.setProfileName(name);
  }

  Future<void> _export(BuildContext context, AppState state) async {
    await Clipboard.setData(ClipboardData(text: state.exportJson()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Өгөгдлийг JSON хэлбэрээр хууллаа.')),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('MY ARC-ийн тухай'),
        content: const Text(
          'Өдөр тутмын ажил, дадал, суралцах ахицаа хөтлөөрэй. '
          'Өөрчлөлтүүд энэ төхөөрөмж дээр хадгалагдана. '
          'Өгөгдөл хадгалах хэсгээс нөөцөө JSON хэлбэрээр хуулж болно.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ойлголоо'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final rows = [
      _SettingRow('profile', 'Профайл', Icons.person_outline_rounded, 'blue', state.profileName),
      const _SettingRow('export', 'Өгөгдөл хуулах', Icons.download_rounded, 'teal'),
      const _SettingRow('help', 'Тусламж', Icons.help_outline_rounded, 'violet'),
    ];

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
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: 1, indent: 66, color: Color(0xFFE8EDF8)),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: IconBadge(icon: rows[i].icon, color: rows[i].color, size: 18),
                  title: Text(rows[i].title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rows[i].value != null)
                        Text(rows[i].value!,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.muted)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.faint),
                    ],
                  ),
                  onTap: () {
                    switch (rows[i].id) {
                      case 'profile':
                        _editProfile(context, state);
                        break;
                      case 'export':
                        _export(context, state);
                        break;
                      case 'help':
                        _showHelp(context);
                        break;
                    }
                  },
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

class _SettingRow {
  final String id;
  final String title;
  final IconData icon;
  final String color;
  final String? value;
  const _SettingRow(this.id, this.title, this.icon, this.color, [this.value]);
}
