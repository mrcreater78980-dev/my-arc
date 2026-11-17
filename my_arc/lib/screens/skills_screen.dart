import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/components.dart';
import 'navigation.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = AppScope.of(context).skills;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Миний чиглэлүүд',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary)),
            const SizedBox(width: 8),
            CountChip('${skills.length} чиглэл'),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth >= 860 ? 2 : 1;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 92,
            ),
            itemBuilder: (context, i) {
              final skill = skills[i];
              final accent = Accent.of(skill.color);
              return Semantics(
                button: true,
                label: '${skill.title}, ${skill.progress}%, Түвшин ${skill.level}',
                child: GlassCard(
                  onTap: () => openSkill(context, skill),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      SkillIcon(skill: skill),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: skill.title,
                                children: [
                                  if (skill.technology != null)
                                    TextSpan(
                                      text: ' (${skill.technology})',
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.muted),
                                    ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 3),
                            Text('Түвшин ${skill.level}',
                                style: const TextStyle(fontSize: 10.5, color: AppColors.secondary)),
                            const SizedBox(height: 8),
                            ProgressBar(value: skill.progress, color: skill.color, height: 6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text.rich(TextSpan(
                        text: '${skill.progress}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: accent.main),
                        children: const [
                          TextSpan(text: '%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        const BottomNote(icon: Icons.auto_awesome, text: 'Өнөөдөр сур. Маргааш бүтээ.'),
      ],
    );
  }
}
