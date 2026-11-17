import 'package:flutter/material.dart';

import '../models/data.dart';
import '../models/learning.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/charts.dart';
import '../widgets/components.dart';
import '../widgets/layout.dart';
import 'navigation.dart';

/// screens.tsx → CategoryDashboard
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.skillId});
  final int skillId;

  static const _statuses = ['Дууссан', 'Дууссан', 'Одоо суралцаж байна', 'Дараагийн алхам', 'Төлөвлөсөн'];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final skill = state.skillById(skillId);
    final sessions = state.sessionsFor(skillId);
    final checked = state.checksFor(skillId);
    final plan = getLearningPlan(skill.id);
    final stats = categoryStats(skill, sessions);
    final finished = skill.progress >= 100;

    final hero = GlassCard(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          ProgressRing(
            value: skill.progress,
            size: 116,
            stroke: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(TextSpan(
                  text: '${skill.progress}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1),
                  children: const [
                    TextSpan(text: '%', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
                  ],
                )),
                Text('Түвшин ${skill.level}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Overline('ТАНЫ СУРАЛЦАХ АЯЛАЛ'),
                const SizedBox(height: 6),
                const Text('Алхам бүр үнэ цэнтэй.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -.6)),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                  text: '${formatThousands(stats.xp)} ',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  children: const [
                    TextSpan(
                        text: '/ 2,000 XP',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted)),
                  ],
                )),
                const SizedBox(height: 8),
                ProgressBar(value: skill.progress),
                const SizedBox(height: 8),
                PositiveChange('+${skill.id == 4 ? 12 : skill.change}% өмнөх 7 хоногоос', size: 10.5),
              ],
            ),
          ),
        ],
      ),
    );

    final chart = GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(child: _PanelTitle('Энэ 7 хоногийн ахиц')),
              SmallDot(color: Color(0xFF7A9FF8)),
              SizedBox(width: 6),
              Text('Ахиц', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 16),
          AreaChart(values: skill.bars),
        ],
      ),
    );

    final roadmap = GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(children: [Expanded(child: _PanelTitle('Суралцах зам')), CountChip('5 алхам')]),
          const SizedBox(height: 14),
          for (var i = 0; i < plan.steps.length; i++)
            _RoadmapStep(
              index: i,
              title: plan.steps[i],
              status: _statuses[i],
              isLast: i == plan.steps.length - 1,
            ),
        ],
      ),
    );

    final todayTasks = GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: _PanelTitle('Өнөөдрийн даалгавар')),
              Text('${checked.where((c) => c).length}/2',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.blue)),
            ],
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < plan.tasks.length; i++)
            ListRow(
              title: plan.tasks[i],
              checked: checked[i],
              onChanged: () => state.toggleLearningCheck(skillId, i),
            ),
        ],
      ),
    );

    return DetailScaffold(
      children: [
        BackHeader(title: skill.title, subtitle: skill.technology ?? 'Миний чиглэлүүд'),
        hero,
        const SizedBox(height: 14),
        ThreeStats(children: [
          StatCard(icon: Icons.track_changes_rounded, color: 'blue', label: 'Дууссан алхам', value: '${stats.steps}', unit: '/15'),
          StatCard(icon: Icons.schedule_rounded, color: 'teal', label: 'Суралцсан цаг', value: '${stats.hours} ', unit: 'ц'),
          StatCard(
              icon: Icons.local_fire_department_outlined,
              color: 'orange',
              label: 'Дараалсан өдөр',
              value: '${stats.streak} ',
              unit: 'өдөр'),
        ]),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          if (c.maxWidth >= 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: [chart, const SizedBox(height: 16), todayTasks])),
                const SizedBox(width: 16),
                Expanded(child: roadmap),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [chart, const SizedBox(height: 16), roadmap, const SizedBox(height: 16), todayTasks],
          );
        }),
        const SizedBox(height: 20),
        PrimaryButton(
          label: finished ? 'Дууссан' : 'Суралцсанаа тэмдэглэх',
          icon: finished ? Icons.check_rounded : Icons.menu_book_rounded,
          onPressed: finished ? null : () => state.logLearning(skillId),
        ),
        const BottomNote(icon: Icons.verified_user_outlined, text: 'Өдөр бүрийн хичээл зүтгэл тань үнэ цэнтэй.'),
      ],
    );
  }
}

class _RoadmapStep extends StatelessWidget {
  const _RoadmapStep({required this.index, required this.title, required this.status, required this.isLast});

  final int index;
  final String title;
  final String status;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = index < 2;
    final current = index == 2;

    Widget node;
    if (done) {
      node = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
      );
    } else if (current) {
      node = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.blue, width: 2),
          boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: .2), blurRadius: 8)],
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
          ),
        ),
      );
    } else {
      node = Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FB),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD8E1F3)),
        ),
        child: Text('${index + 1}',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.muted)),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                node,
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: done ? AppColors.blue.withValues(alpha: .4) : const Color(0xFFE1E7F4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                        color: index > 2 ? AppColors.secondary : AppColors.navy,
                      )),
                  const SizedBox(height: 2),
                  Text(status,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: current ? AppColors.blue : AppColors.muted,
                      )),
                ],
              ),
            ),
          ),
          if (current)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -.4));
}
