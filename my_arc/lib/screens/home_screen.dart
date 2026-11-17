import 'package:flutter/material.dart';

import '../models/data.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/components.dart';
import 'navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});
  final ValueChanged<AppPage> onNavigate;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final tasks = state.tasks;
    final habits = state.habits;
    final waiting = tasks.where((t) => t.due == todayLabel && !t.done).length;
    final featuredHabits = [if (habits.isNotEmpty) habits[0], if (habits.length > 2) habits[2]];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _OverviewCard(),
        const SizedBox(height: 28),
        ResponsivePair(
          first: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                title: 'Өнөөдрийн ажил',
                link: 'Бүгдийг харах',
                onTap: () => onNavigate(AppPage.tasks),
              ),
              GlassCard(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                child: Column(
                  children: [
                    for (final task in tasks.take(2))
                      ListRow(
                        title: task.title,
                        checked: task.done,
                        onChanged: () => state.toggleTask(task.id),
                        trailing: TimeLabel(task.time),
                      ),
                    _Footnote(
                      dot: const Color(0xFF7A9FF8),
                      text: '$waiting ажил таныг хүлээж байна',
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
          second: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                title: 'Өнөөдрийн дадал',
                link: 'Бүгдийг харах',
                onTap: () => onNavigate(AppPage.habits),
              ),
              GlassCard(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                child: Column(
                  children: [
                    for (final habit in featuredHabits)
                      ListRow(
                        title: habit.title,
                        checked: habit.done,
                        onChanged: () => state.toggleHabit(habit.id),
                        trailing: Streak(days: habit.streak),
                      ),
                    const _Footnote(
                      dot: Color(0xFF61CFBE),
                      text: 'Өдөр бүрийн жижиг ялалт',
                      icon: Icons.local_florist_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SectionHeading(title: 'Миний чиглэлүүд', count: '${state.skills.length} чиглэл'),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth >= 1000 ? 5 : (c.maxWidth >= 640 ? 3 : 2);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 196,
            ),
            itemBuilder: (context, i) {
              final skill = state.skills[i];
              return SkillCard(skill: skill, onTap: () => openSkill(context, skill));
            },
          );
        }),
        const BottomNote(text: 'Өнөөдрийн хичээл зүтгэл, маргаашийн шинэ боломж.'),
      ],
    );
  }
}

class _Footnote extends StatelessWidget {
  const _Footnote({required this.dot, required this.text, required this.icon});
  final Color dot;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE8EDF8)))),
      child: Row(
        children: [
          SmallDot(color: dot),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.secondary)),
          ),
          Icon(icon, size: 14, color: AppColors.faint),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final xp = state.xp;
    final progress = state.progress;

    final level = Row(
      children: [
        Container(
          width: 62,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE5EEFF), Color(0xFFD7E1FF)],
            ),
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.workspace_premium_outlined, size: 30, color: AppColors.blue),
              Positioned(top: 10, right: 10, child: Icon(Icons.auto_awesome, size: 13, color: AppColors.blue)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Overline('ТАНЫ ТҮВШИН'),
            SizedBox(height: 4),
            Text('Түвшин 12', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -.9)),
            SizedBox(height: 8),
            _StreakPill(),
          ],
        ),
      ],
    );

    final xpArea = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text('Дараагийн түвшин рүү', style: TextStyle(fontSize: 11, color: AppColors.secondary)),
            ),
            Icon(Icons.auto_awesome, size: 14, color: AppColors.faint),
          ],
        ),
        const SizedBox(height: 12),
        ProgressBar(value: xp / 30),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text.rich(TextSpan(
                text: '${formatThousands(xp)} ',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                children: const [
                  TextSpan(
                      text: '/ 3,000 XP',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
                ],
              )),
            ),
            Text('${(xp / 30).round()}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue)),
          ],
        ),
      ],
    );

    final daily = Row(
      children: [
        ProgressRing(value: progress.percent, size: 90, stroke: 7),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Өнөөдрийн ахиц', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${progress.total}-оос ${progress.done} нь хийгдсэн',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text('Сайн явж байна!',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.positive)),
                  Icon(Icons.north_east_rounded, size: 13, color: AppColors.positive),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(builder: (context, c) {
        if (c.maxWidth >= 820) {
          return Row(
            children: [
              Expanded(flex: 105, child: level),
              const SizedBox(width: 32),
              Expanded(flex: 100, child: xpArea),
              const SizedBox(width: 32),
              Expanded(flex: 115, child: daily),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [level, const SizedBox(height: 22), xpArea, const SizedBox(height: 22), daily],
        );
      }),
    );
  }
}

class _StreakPill extends StatelessWidget {
  const _StreakPill();

  @override
  Widget build(BuildContext context) => const Streak(days: 7, pill: true, label: 'өдөр дараалан');
}
