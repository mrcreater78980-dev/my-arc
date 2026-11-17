import 'package:flutter/material.dart';

import '../models/data.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/components.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final filter = state.filter;
    final visible = filterTasks(state.tasks, filter);
    final planned = filterTasks(state.tasks, TaskFilter.planned);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 10,
          spacing: 12,
          children: [
            FilterTabs<TaskFilter>(
              items: const [
                (TaskFilter.today, 'Өнөөдөр'),
                (TaskFilter.planned, 'Төлөвлөсөн'),
                (TaskFilter.completed, 'Дууссан'),
              ],
              selected: filter,
              badge: '${visible.length}',
              onSelect: state.setFilter,
            ),
            Text('${state.tasksDone} / ${state.tasks.length} хийгдсэн',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: visible.isEmpty
              ? EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: filter == TaskFilter.completed ? 'Дууссан ажил алга' : 'Одоогоор ажил алга',
                  text: 'Шинэ ажил нэмж, эхний алхмаа хийгээрэй.',
                )
              : Column(
                  children: [
                    for (final task in visible)
                      ListRow(
                        large: true,
                        title: task.title,
                        subtitle: task.due,
                        checked: task.done,
                        onChanged: () => state.toggleTask(task.id),
                        trailing: task.time != null
                            ? TimeLabel(task.time)
                            : const Icon(Icons.calendar_today_outlined, size: 17, color: AppColors.faint),
                      ),
                  ],
                ),
        ),
        if (filter == TaskFilter.today && planned.isNotEmpty) ...[
          const SizedBox(height: 26),
          const SectionHeading(title: 'Төлөвлөсөн'),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Column(
              children: [
                for (final task in planned)
                  ListRow(
                    large: true,
                    title: task.title,
                    subtitle: task.due,
                    checked: task.done,
                    onChanged: () => state.toggleTask(task.id),
                    trailing: const Icon(Icons.calendar_today_outlined, size: 17, color: AppColors.faint),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 17, color: AppColors.faint),
            SizedBox(width: 8),
            Text('Нэг нэгээр нь. Та чадна.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }
}
