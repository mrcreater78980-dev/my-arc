import 'package:flutter/material.dart';

import '../models/data.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/charts.dart';
import '../widgets/components.dart';
import 'navigation.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final monthly = state.period == ReportPeriod.month;
    final taskDelta = state.tasksDone - 1;
    final habitDelta = state.habitDone - 2;
    final sessions = state.totalLearningSessions;

    final done = (monthly ? 64 : 18) + taskDelta;
    final habitPercent = ((monthly ? 79 : 72) + habitDelta * 7).clamp(0, 100);
    final earnedXp = (monthly ? 3240 : 840) + taskDelta * 40 + sessions * 100;
    final topSkills = ([...state.skills]..sort((a, b) => b.progress.compareTo(a.progress))).take(4).toList();
    final topHabits = ([...state.habits]..sort((a, b) => b.streak.compareTo(a.streak))).take(3).toList();

    final chartCard = GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _PanelTitle(monthly ? 'Энэ сарын ахиц' : 'Энэ 7 хоногийн ахиц')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F6EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PositiveChange('$habitPercent%', size: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AreaChart(
            monthly: monthly,
            values: monthly ? const [22, 40, 35, 61, 52, 78, 79] : [20, 42, 34, 68, 54, 80, habitPercent],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(color: Color(0xFFE2F6EC), shape: BoxShape.circle),
                child: const Icon(Icons.north_east_rounded, size: 13, color: AppColors.positive),
              ),
              const SizedBox(width: 8),
              Text(monthly ? 'Өмнөх сараас ' : 'Өмнөх 7 хоногоос ',
                  style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
              const Text('+12%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.positive)),
            ],
          ),
        ],
      ),
    );

    final donutCard = GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(child: _PanelTitle('Чиглэл тус бүрийн ахиц')),
              IconBadge(icon: Icons.track_changes_rounded, color: 'neutral', size: 15, box: 30),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              DonutChart(skills: topSkills),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < topSkills.length; i++)
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => openSkill(context, topSkills[i]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                          child: Row(
                            children: [
                              SmallDot(color: donutColors[i % donutColors.length]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(topSkills[i].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                              ),
                              Text('${topSkills[i].progress}%',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    const rankColors = ['orange', 'blue', 'violet'];
    final bestHabits = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading(title: 'Хамгийн сайн дадал'),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              for (var i = 0; i < topHabits.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      IconBadge(icon: Icons.menu_book_rounded, color: rankColors[i], size: 16, box: 34),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(topHabits[i].title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      Streak(days: topHabits[i].streak, pill: true),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            FilterTabs<ReportPeriod>(
              items: const [(ReportPeriod.week, '7 хоног'), (ReportPeriod.month, 'Сар')],
              selected: state.period,
              onSelect: state.setPeriod,
            ),
            const Spacer(),
            const Icon(Icons.schedule_rounded, size: 12, color: AppColors.muted),
            const SizedBox(width: 4),
            Text(monthly ? '5 сар' : '5 сарын 20–26',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 16),
        ThreeStats(children: [
          StatCard(icon: Icons.check_rounded, color: 'blue', label: 'Хийсэн ажил', value: '$done', change: '+3'),
          StatCard(
              icon: Icons.track_changes_rounded,
              color: 'teal',
              label: 'Дадлын хувь',
              value: '$habitPercent%',
              change: '+8%'),
          StatCard(
              icon: Icons.workspace_premium_outlined,
              color: 'violet',
              label: 'Нийт XP',
              value: formatThousands(earnedXp),
              change: '+12%'),
        ]),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, c) {
          if (c.maxWidth >= 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: chartCard),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(children: [donutCard, const SizedBox(height: 20), bestHabits]),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [chartCard, const SizedBox(height: 20), donutCard, const SizedBox(height: 24), bestHabits],
          );
        }),
      ],
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
