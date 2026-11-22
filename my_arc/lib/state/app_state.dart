import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data.dart';

enum ReportPeriod { week, month }

/// App.tsx доторх useState-үүдийг нэгтгэсэн төлөв.
class AppState extends ChangeNotifier {
  List<Task> tasks = List.of(initialTasks);
  List<Habit> habits = List.of(initialHabits);
  List<Skill> skills = List.of(initialSkills);
  TaskFilter filter = TaskFilter.today;
  ReportPeriod period = ReportPeriod.week;
  String profileName = 'Бат';
  final Map<int, List<bool>> _learningChecks = {};
  final Map<int, int> _learningSessions = {};
  Future<void> _pendingSave = Future<void>.value();

  static const _storageKey = 'my_arc_state_v1';

  static Future<AppState> load() async {
    final state = AppState();
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getString(_storageKey);
      if (saved == null) return state;
      final data = jsonDecode(saved) as Map<String, dynamic>;
      state.tasks = (data['tasks'] as List<dynamic>)
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
      state.habits = (data['habits'] as List<dynamic>)
          .map((item) => Habit.fromJson(item as Map<String, dynamic>))
          .toList();
      state.skills = (data['skills'] as List<dynamic>)
          .map((item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();
      state.filter = TaskFilter.values.byName(data['filter'] as String);
      state.period = ReportPeriod.values.byName(data['period'] as String);
      state.profileName = data['profileName'] as String? ?? 'Бат';
      for (final entry in (data['learningChecks'] as Map<String, dynamic>).entries) {
        state._learningChecks[int.parse(entry.key)] = (entry.value as List<dynamic>).cast<bool>();
      }
      for (final entry in (data['learningSessions'] as Map<String, dynamic>).entries) {
        state._learningSessions[int.parse(entry.key)] = entry.value as int;
      }
    } on Object {
      // A corrupted or outdated save should not prevent the app from opening.
      return AppState();
    }
    return state;
  }

  void _save() {
    final snapshot = exportJson();
    _pendingSave = _pendingSave.then((_) => _persist(snapshot));
  }

  String exportJson() => jsonEncode({
      'tasks': tasks.map((item) => item.toJson()).toList(),
      'habits': habits.map((item) => item.toJson()).toList(),
      'skills': skills.map((item) => item.toJson()).toList(),
      'profileName': profileName,
      'filter': filter.name,
      'period': period.name,
      'learningChecks': {
        for (final entry in _learningChecks.entries) entry.key.toString(): entry.value,
      },
      'learningSessions': {
        for (final entry in _learningSessions.entries) entry.key.toString(): entry.value,
      },
    });

  void setProfileName(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty || cleaned == profileName) return;
    profileName = cleaned;
    notifyListeners();
    _save();
  }

  Future<void> _persist(String snapshot) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_storageKey, snapshot);
    } on Object {
      // Keep the current session usable when device storage is unavailable.
    }
  }

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
    _save();
  }

  void toggleHabit(int id) {
    habits = [for (final h in habits) h.id == id ? h.copyWith(done: !h.done) : h];
    notifyListeners();
    _save();
  }

  void setFilter(TaskFilter value) {
    filter = value;
    notifyListeners();
    _save();
  }

  void setPeriod(ReportPeriod value) {
    period = value;
    notifyListeners();
    _save();
  }

  void toggleLearningCheck(int skillId, int index) {
    final checks = List.of(checksFor(skillId));
    checks[index] = !checks[index];
    _learningChecks[skillId] = checks;
    notifyListeners();
    _save();
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
    _save();
  }

  void addTask(String title) {
    tasks = [
      ...tasks,
      Task(id: _nextId(tasks.map((task) => task.id)), title: title, due: todayLabel, done: false),
    ];
    notifyListeners();
    _save();
  }

  void addHabit(String title) {
    habits = [
      ...habits,
      Habit(id: _nextId(habits.map((habit) => habit.id)), title: title, streak: 0, done: false),
    ];
    notifyListeners();
    _save();
  }

  int _nextId(Iterable<int> ids) => ids.fold<int>(0, (largest, id) => id > largest ? id : largest) + 1;
}

/// Provider багцгүйгээр төлөвийг мод даяар түгээх.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
