// learning.ts → Dart
import 'dart:math' as math;
import 'dart:ui' show Offset;

import 'data.dart';

class LearningPlan {
  final List<String> steps;
  final List<String> tasks; // яг 2 ширхэг

  const LearningPlan({required this.steps, required this.tasks});
}

const Map<int, LearningPlan> _plans = {
  1: LearningPlan(
    steps: [
      'Python хэлний үндэс',
      'Нөхцөл ба давталт',
      'Функц ба модулиуд',
      'Файлтай ажиллах',
      'Бие даасан төсөл хийх',
    ],
    tasks: ['Python функц бичих', 'Жижиг тооцоолуур хийх'],
  ),
  2: LearningPlan(
    steps: [
      'Өгөгдлийн бүтцийн үндэс',
      'Массив ба холбоост жагсаалт',
      'Эрэмбэлэх алгоритм',
      'Мод ба граф',
      'Алгоритмын бодлого бодох',
    ],
    tasks: ['Эрэмбэлэх алгоритм сурах', 'Алгоритмын 3 бодлого бодох'],
  ),
  3: LearningPlan(
    steps: [
      'Вэбийн үндэс',
      'Хуудасны зохиомж',
      'Харилцан үйлдэл нэмэх',
      'API-тай холбох',
      'Вэб төслөө нийтлэх',
    ],
    tasks: ['Уян хатан зохиомж сурах', 'Танилцуулгын 3 хуудас хийх'],
  ),
  4: LearningPlan(
    steps: [
      'Dart хэлний үндэс',
      'Flutter суулгах, анхны апп',
      'Widget, дэлгэцийн зохиомж',
      'Төлөв удирдах (Provider)',
      'Өгөгдөл хадгалах, төсөл дуусгах',
    ],
    tasks: ['ListView, GridView сурах', 'Анхны 3 дэлгэцтэй апп хийх'],
  ),
  5: LearningPlan(
    steps: [
      'Өгөгдлийн сангийн үндэс',
      'SQL асуулга бичих',
      'Хүснэгтүүд холбох',
      'Өгөгдөл боловсруулах',
      'Өгөгдлийн сангийн төсөл хийх',
    ],
    tasks: ['SQL хүснэгт холбох', 'SQL дасгал 5 бодох'],
  ),
  6: LearningPlan(
    steps: [
      'Git-ийн үндэс',
      'Өөрчлөлтөө бүртгэх',
      'Салбар ба нэгтгэл',
      'GitHub дээр хамтрах',
      'Багийн төслийг удирдах',
    ],
    tasks: ['Git салбар үүсгэх', 'GitHub дээр өөрчлөлт нэгтгэх'],
  ),
  7: LearningPlan(
    steps: [
      'Серверийн үндэс',
      'API үүсгэх',
      'Өгөгдлийн сантай холбох',
      'Хандалт ба хамгаалалт',
      'Серверийн төслөө нийтлэх',
    ],
    tasks: ['API хүсэлт сурах', 'Анхны API үүсгэх'],
  ),
  8: LearningPlan(
    steps: [
      'Программын бүтцийн үндэс',
      'Хариуцлагыг тусгаарлах',
      'Зохиомжийн хэв маяг',
      'Модулиудын уялдаа',
      'Төслийн зохиомж гаргах',
    ],
    tasks: ['Зохиомжийн хэв маяг судлах', 'Төслийн бүтцээ зураглах'],
  ),
  9: LearningPlan(
    steps: [
      'Тестийн үндэс',
      'Нэгж тест бичих',
      'Алдааг оношлох',
      'Нэгдсэн тест хийх',
      'Тестийг автоматжуулах',
    ],
    tasks: ['Нэгж тест бичих', 'Төслийн 3 алдаа засах'],
  ),
  10: LearningPlan(
    steps: [
      'Техникийн үгсийн сан',
      'Баримт бичиг унших',
      'Англиар тайлбарлах',
      'Ярилцлагад бэлтгэх',
      'Ажлын танилцуулга бэлтгэх',
    ],
    tasks: ['Англи үг 20 цээжлэх', 'Төслөө англиар танилцуулах'],
  ),
};

LearningPlan getLearningPlan(int skillId) => _plans[skillId] ?? _plans[1]!;

class CategoryStats {
  final int steps;
  final int hours;
  final int streak;
  final int xp;

  const CategoryStats({
    required this.steps,
    required this.hours,
    required this.streak,
    required this.xp,
  });

  @override
  bool operator ==(Object other) =>
      other is CategoryStats &&
      other.steps == steps &&
      other.hours == hours &&
      other.streak == streak &&
      other.xp == xp;

  @override
  int get hashCode => Object.hash(steps, hours, streak, xp);

  @override
  String toString() => 'CategoryStats(steps: $steps, hours: $hours, streak: $streak, xp: $xp)';
}

CategoryStats categoryStats(Skill skill, int sessions) {
  final int base = skill.id == 4 ? 55 : skill.progress - sessions * 5;
  return CategoryStats(
    steps: math.min(15, (base * 0.15).round() + sessions),
    hours: math.max(1, (base * 0.22).round()) + sessions,
    streak: skill.id == 4 ? 5 : math.max(2, skill.level + 1),
    xp: (skill.progress * 20).round(),
  );
}

/// Гөлгөр шугамын нэг cubic сегмент.
class CubicSegment {
  final Offset c1;
  final Offset c2;
  final Offset end;
  const CubicSegment(this.c1, this.c2, this.end);
}

class ChartGeometry {
  final List<Offset> points;
  final List<CubicSegment> segments;
  final double baseline;
  final String line; // SVG path (тест, дибагт)
  final String area;

  const ChartGeometry({
    required this.points,
    required this.segments,
    required this.baseline,
    required this.line,
    required this.area,
  });
}

String _n(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

ChartGeometry chartGeometry(
  List<num> values, {
  double width = 300,
  double height = 126,
  double padding = 8,
}) {
  final baseline = height - padding;
  final points = <Offset>[
    for (var i = 0; i < values.length; i++)
      Offset(
        padding + (i * (width - padding * 2)) / math.max(1, values.length - 1),
        baseline - (values[i].clamp(0, 100) / 100) * (height - padding * 2),
      ),
  ];
  if (points.isEmpty) {
    return ChartGeometry(
        points: points, segments: const [], baseline: baseline, line: '', area: '');
  }

  final segments = <CubicSegment>[];
  final line = StringBuffer('M ${_n(points[0].dx)} ${_n(points[0].dy)}');
  for (var i = 1; i < points.length; i++) {
    final prev = points[i - 1];
    final cur = points[i];
    final before = points[math.max(0, i - 2)];
    final after = points[math.min(points.length - 1, i + 1)];
    final c1 = Offset(prev.dx + (cur.dx - before.dx) / 6, prev.dy + (cur.dy - before.dy) / 6);
    final c2 = Offset(cur.dx - (after.dx - prev.dx) / 6, cur.dy - (after.dy - prev.dy) / 6);
    segments.add(CubicSegment(c1, c2, cur));
    line.write(' C ${_n(c1.dx)} ${_n(c1.dy)}, ${_n(c2.dx)} ${_n(c2.dy)}, ${_n(cur.dx)} ${_n(cur.dy)}');
  }
  final lineStr = line.toString();
  return ChartGeometry(
    points: points,
    segments: segments,
    baseline: baseline,
    line: lineStr,
    area:
        '$lineStr L ${_n(points.last.dx)} ${_n(baseline)} L ${_n(points.first.dx)} ${_n(baseline)} Z',
  );
}
