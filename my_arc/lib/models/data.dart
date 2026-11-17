// data.ts → Dart
enum AppPage { home, tasks, habits, skills, progress }

enum TaskFilter { today, planned, completed }

const String todayLabel = 'Өнөөдөр';

class Task {
  final int id;
  final String title;
  final String due;
  final String? time;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    required this.due,
    this.time,
    required this.done,
  });

  Task copyWith({bool? done}) =>
      Task(id: id, title: title, due: due, time: time, done: done ?? this.done);
}

class Habit {
  final int id;
  final String title;
  final int streak;
  final bool done;

  const Habit({
    required this.id,
    required this.title,
    required this.streak,
    required this.done,
  });

  Habit copyWith({bool? done}) =>
      Habit(id: id, title: title, streak: streak, done: done ?? this.done);
}

class Skill {
  final int id;
  final String title;
  final String? technology;
  final int progress;
  final int level;
  final int change;
  final String color; // blue | violet | teal
  final String icon;
  final List<int> bars;

  const Skill({
    required this.id,
    required this.title,
    this.technology,
    required this.progress,
    required this.level,
    required this.change,
    required this.color,
    required this.icon,
    required this.bars,
  });

  Skill copyWith({int? progress}) => Skill(
        id: id,
        title: title,
        technology: technology,
        progress: progress ?? this.progress,
        level: level,
        change: change,
        color: color,
        icon: icon,
        bars: bars,
      );
}

const List<Task> initialTasks = [
  Task(id: 1, title: 'Хичээлийн даалгавар хийх', due: 'Өнөөдөр', time: '18:00', done: true),
  Task(id: 2, title: 'Flutter UI зурах', due: 'Өнөөдөр', time: '20:00', done: false),
  Task(id: 3, title: 'Git-ийн үндэс уншиж дуусгах', due: 'Өнөөдөр', done: false),
  Task(id: 4, title: 'SQL дасгал 5 бодох', due: 'Маргааш', done: false),
  Task(id: 5, title: 'Англи үг 20 цээжлэх', due: 'Баасан', done: false),
];

const List<Habit> initialHabits = [
  Habit(id: 1, title: 'Өглөө 6 цагт босох', streak: 7, done: true),
  Habit(id: 2, title: '10 хуудас ном унших', streak: 12, done: true),
  Habit(id: 3, title: 'Код бичих 1 цаг', streak: 5, done: false),
  Habit(id: 4, title: 'Англи хэл 20 минут', streak: 3, done: false),
];

const List<Skill> initialSkills = [
  Skill(
    id: 1,
    title: 'Програмчлалын үндэс',
    technology: 'Python',
    progress: 70,
    level: 4,
    change: 8,
    color: 'blue',
    icon: 'code',
    bars: [25, 40, 31, 55, 44, 68, 85],
  ),
  Skill(
    id: 2,
    title: 'Өгөгдлийн бүтэц ба алгоритм',
    progress: 45,
    level: 3,
    change: 5,
    color: 'violet',
    icon: 'network',
    bars: [20, 34, 28, 50, 43, 60, 73],
  ),
  Skill(
    id: 3,
    title: 'Вэб хөгжүүлэлт',
    progress: 60,
    level: 3,
    change: 12,
    color: 'teal',
    icon: 'globe',
    bars: [28, 38, 32, 56, 48, 70, 90],
  ),
  Skill(
    id: 4,
    title: 'Гар утасны апп',
    technology: 'Flutter, Dart',
    progress: 55,
    level: 2,
    change: 7,
    color: 'blue',
    icon: 'phone',
    bars: [20, 38, 32, 46, 40, 64, 78],
  ),
  Skill(
    id: 5,
    title: 'Өгөгдлийн сан',
    technology: 'SQL',
    progress: 35,
    level: 2,
    change: 4,
    color: 'violet',
    icon: 'database',
    bars: [16, 28, 22, 42, 36, 53, 65],
  ),
  Skill(
    id: 6,
    title: 'Git ба GitHub',
    progress: 80,
    level: 5,
    change: 10,
    color: 'teal',
    icon: 'git',
    bars: [32, 46, 40, 61, 53, 78, 95],
  ),
  Skill(
    id: 7,
    title: 'Backend ба API',
    progress: 20,
    level: 1,
    change: 3,
    color: 'blue',
    icon: 'server',
    bars: [12, 24, 20, 32, 28, 44, 53],
  ),
  Skill(
    id: 8,
    title: 'Программ хангамжийн зохиомж',
    progress: 25,
    level: 1,
    change: 5,
    color: 'violet',
    icon: 'layers',
    bars: [15, 25, 20, 38, 30, 48, 62],
  ),
  Skill(
    id: 9,
    title: 'Тест ба алдаа засах',
    progress: 30,
    level: 2,
    change: 6,
    color: 'teal',
    icon: 'bug',
    bars: [18, 30, 24, 42, 35, 55, 70],
  ),
  Skill(
    id: 10,
    title: 'Англи хэл ба карьер',
    progress: 40,
    level: 2,
    change: 8,
    color: 'blue',
    icon: 'book',
    bars: [20, 34, 28, 48, 40, 63, 80],
  ),
];

List<Task> filterTasks(List<Task> tasks, TaskFilter filter) {
  switch (filter) {
    case TaskFilter.completed:
      return tasks.where((t) => t.done).toList();
    case TaskFilter.planned:
      return tasks.where((t) => t.due != todayLabel && !t.done).toList();
    case TaskFilter.today:
      return tasks.where((t) => t.due == todayLabel).toList();
  }
}

class DailyProgress {
  final int total;
  final int done;
  final int percent;

  const DailyProgress({required this.total, required this.done, required this.percent});

  @override
  bool operator ==(Object other) =>
      other is DailyProgress &&
      other.total == total &&
      other.done == done &&
      other.percent == percent;

  @override
  int get hashCode => Object.hash(total, done, percent);

  @override
  String toString() => 'DailyProgress(total: $total, done: $done, percent: $percent)';
}

DailyProgress dailyProgress(List<Task> tasks, List<Habit> habits) {
  final today = tasks.where((t) => t.due == todayLabel).toList();
  final total = today.length + habits.length;
  // Анхны өдрийн төлөвт нэг дууссан суралцах сешн багтсан.
  final rawDone =
      today.where((t) => t.done).length + habits.where((h) => h.done).length + 1;
  final done = rawDone < total ? rawDone : total;
  return DailyProgress(
    total: total,
    done: done,
    percent: total == 0 ? 0 : (done / total * 100).round(),
  );
}

/// JS-ийн toLocaleString("en-US")-тэй адил: 2040 → "2,040"
String formatThousands(int value) {
  final s = value.abs().toString();
  final buf = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
