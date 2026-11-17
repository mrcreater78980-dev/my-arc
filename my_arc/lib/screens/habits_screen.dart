import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/components.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key, required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final habits = state.habits;
    final done = state.habitDone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Overline('ТУУШТАЙ БАЙДЛЫН ХҮЧ'),
                    const SizedBox(height: 6),
                    const Text('Өнөөдөр', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.6)),
                    const SizedBox(height: 6),
                    Text.rich(TextSpan(
                      text: '$done ',
                      style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1.5),
                      children: [
                        TextSpan(
                          text: '/ ${habits.length}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.muted),
                        ),
                      ],
                    )),
                    const SizedBox(height: 12),
                    ProgressBar(value: habits.isEmpty ? 0 : done / habits.length * 100, color: 'teal'),
                    const SizedBox(height: 10),
                    const Text('Өдөр бүр нэг алхам урагш.',
                        style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const _HabitArt(),
            ],
          ),
        ),
        const SizedBox(height: 26),
        SectionHeading(title: 'Өдөр бүрийн дадал', count: '${habits.length} дадал'),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Column(
            children: [
              for (final habit in habits)
                ListRow(
                  large: true,
                  title: habit.title,
                  checked: habit.done,
                  onChanged: () => state.toggleHabit(habit.id),
                  trailing: Streak(days: habit.streak, pill: true),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(label: 'Дадал нэмэх', icon: Icons.add_rounded, onPressed: onAdd),
      ],
    );
  }
}

class _HabitArt extends StatelessWidget {
  const _HabitArt();

  @override
  Widget build(BuildContext context) {
    Widget ring(double size, double alpha) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.teal.withValues(alpha: alpha), width: 1.2),
          ),
        );
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ring(120, .14),
          ring(88, .24),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: Color(0xFFE0F5F1), shape: BoxShape.circle),
          ),
          const Icon(Icons.local_florist_outlined, size: 44, color: AppColors.teal),
        ],
      ),
    );
  }
}
