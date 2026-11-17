import 'package:flutter/widgets.dart';

import '../models/data.dart';

enum ReportPeriod { week, month }

/// App.tsx доторх useState-үүдийг нэгтгэсэн төлөв.
class AppState extends ChangeNotifier {
  List<Task> tasks = List.of(initialTasks);
  List<Habit> habits = List.of(initialHabits);
  List<Skill> skills = List.of(initialSkills);
  TaskFilter filter = TaskFilter.today;
  ReportPeriod period = ReportPeriod.week;
  final Map<int, List<bool>> _learningChecks = {};
  final Map<int, int> _learningSessions = {};

  DailyProgress get progress => dailyProgress(tasks, habits);
  int get habitDone => habits.where((h) => h.done).length;
  int get tasksDone => tasks.where((t) => t.done).length;
  int get totalLearningSessions => _learningSessions.values.fold(0, (a, b) => a + b);
  int get xp => 2040 + (progress.done - 4) * 40 + totalLearningSessions * 100;

  Skill skillById(int id) => skills.firstWhere((s) => s.id == id);
  int sessionsFor(int skillId) => _learningSessions[skillId] ?? 0;
  List<bool> checksFor(int skillId) => _learningChecks[skillId] ?? const [true, false];

  void toggleTask(int id) {
    tasks = [for (final t in tasks) t.id == id ? t.copyWith(done: !t.done) : t];
    notifyListeners();
  }

  void toggleHabit(int id) {
    habits = [for (final h in habits) h.id == id ? h.copyWith(done: !h.done) : h];
    notifyListeners();
  }

  void setFilter(TaskFilter value) {
    filter = value;
    notifyListeners();
  }

  void setPeriod(ReportPeriod value) {
    period = value;
    notifyListeners();
  }

  void toggleLearningCheck(int skillId, int index) {
    final checks = List.of(checksFor(skillId));
    checks[index] = !checks[index];
    _learningChecks[skillId] = checks;
    notifyListeners();
  }

  void logLearning(int skillId) {
    final skill = skillById(skillId);
    if (skill.progress >= 100) return;
    skills = [
      for (final s in skills)
        s.id == skillId ? s.copyWith(progress: (s.progress + 5).clamp(0, 100)) : s,
    ];
    _learningSessions[skillId] = sessionsFor(skillId) + 1;
    notifyListeners();
  }

  void addTask(String title) {
    tasks = [
      ...tasks,
      Task(id: DateTime.now().millisecondsSinceEpoch, title: title, due: todayLabel, done: false),
    ];
    notifyListeners();
  }

  void addHabit(String title) {
    habits = [
      ...habits,
      Habit(id: DateTime.now().millisecondsSinceEpoch, title: title, streak: 0, done: false),
    ];
    notifyListeners();
  }
}

/// Provider багцгүйгээр төлөвийг мод даяар түгээх.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
