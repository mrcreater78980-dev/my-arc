// data.test.ts → Dart (flutter test)
import 'package:flutter_test/flutter_test.dart';
import 'package:my_arc/models/data.dart';
import 'package:my_arc/models/learning.dart';

List<int> ids(List<Task> tasks) => tasks.map((t) => t.id).toList();

void main() {
  test('initial dashboard matches the requested daily snapshot', () {
    expect(dailyProgress(initialTasks, initialHabits),
        const DailyProgress(total: 7, done: 4, percent: 57));
    expect(initialSkills.length, 10);
    expect(initialHabits.where((h) => h.done).length, 2);
  });

  test('task filters select today, upcoming and completed tasks', () {
    expect(ids(filterTasks(initialTasks, TaskFilter.today)), [1, 2, 3]);
    expect(ids(filterTasks(initialTasks, TaskFilter.planned)), [4, 5]);
    expect(ids(filterTasks(initialTasks, TaskFilter.completed)), [1]);
  });

  test('completed planned tasks leave the planned list', () {
    final updated = [for (final t in initialTasks) t.id == 4 ? t.copyWith(done: true) : t];
    expect(ids(filterTasks(updated, TaskFilter.planned)), [5]);
    expect(ids(filterTasks(updated, TaskFilter.completed)), [1, 4]);
  });

  test('toggling tasks and habits updates the shared daily progress', () {
    final tasks = [for (final t in initialTasks) t.id == 2 ? t.copyWith(done: true) : t];
    expect(dailyProgress(tasks, initialHabits),
        const DailyProgress(total: 7, done: 5, percent: 71));
    final habits = [for (final h in initialHabits) h.id == 3 ? h.copyWith(done: true) : h];
    expect(dailyProgress(tasks, habits), const DailyProgress(total: 7, done: 6, percent: 86));
  });

  test('adding tasks updates the total; progress never exceeds 100%', () {
    final tasks = [
      ...initialTasks,
      const Task(id: 6, title: 'Шинэ ажил', due: 'Өнөөдөр', done: false),
    ];
    expect(dailyProgress(tasks, initialHabits).total, 8);
    expect(
      dailyProgress(
        [for (final t in initialTasks) t.copyWith(done: true)],
        [for (final h in initialHabits) h.copyWith(done: true)],
      ).percent,
      100,
    );
    expect(dailyProgress(const [], const []), const DailyProgress(total: 0, done: 0, percent: 0));
  });

  test('mobile category starts with the requested dashboard metrics and roadmap', () {
    final mobile = initialSkills.firstWhere((s) => s.id == 4);
    expect(categoryStats(mobile, 0), const CategoryStats(steps: 8, hours: 12, streak: 5, xp: 1100));
    expect(getLearningPlan(4).steps, [
      'Dart хэлний үндэс',
      'Flutter суулгах, анхны апп',
      'Widget, дэлгэцийн зохиомж',
      'Төлөв удирдах (Provider)',
      'Өгөгдөл хадгалах, төсөл дуусгах',
    ]);
    expect(getLearningPlan(4).tasks, ['ListView, GridView сурах', 'Анхны 3 дэлгэцтэй апп хийх']);
  });

  test('each category has its own five-step learning plan and two tasks', () {
    for (final skill in initialSkills) {
      expect(getLearningPlan(skill.id).steps.length, 5);
      expect(getLearningPlan(skill.id).tasks.length, 2);
    }
    expect(getLearningPlan(1).steps, isNot(equals(getLearningPlan(4).steps)));
  });

  test('logging learning updates category steps, time and XP without exceeding the step target',
      () {
    final mobile = initialSkills.firstWhere((s) => s.id == 4);
    expect(categoryStats(mobile.copyWith(progress: 60), 1),
        const CategoryStats(steps: 9, hours: 13, streak: 5, xp: 1200));
    expect(categoryStats(mobile.copyWith(progress: 100), 9).steps, 15);
  });

  test('smooth chart geometry is finite, bounded and handles empty data', () {
    final empty = chartGeometry(const []);
    expect(empty.line, '');
    expect(empty.area, '');
    expect(empty.points, isEmpty);

    final result = chartGeometry(const [-10, 20, 45, 75, 120]);
    expect(result.points.length, 5);
    expect(result.line.startsWith('M '), isTrue);
    expect(result.line.contains(' C '), isTrue);
    expect(result.area.endsWith(' Z'), isTrue);
    expect(result.line.contains('NaN'), isFalse);
    expect(
      result.points.every((p) => p.dx >= 8 && p.dx <= 292 && p.dy >= 8 && p.dy <= 118),
      isTrue,
    );
  });

  test('formatThousands mirrors toLocaleString("en-US")', () {
    expect(formatThousands(2040), '2,040');
    expect(formatThousands(840), '840');
    expect(formatThousands(1234567), '1,234,567');
  });
}
