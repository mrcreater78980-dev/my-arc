// screens.tsx доторх AreaChart, DonutChart → CustomPainter
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/data.dart';
import '../models/learning.dart';
import '../theme.dart';

class AreaChart extends StatelessWidget {
  const AreaChart({super.key, required this.values, this.monthly = false, this.color = AppColors.blue});

  final List<int> values;
  final bool monthly;
  final Color color;

  static const _weekLabels = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];
  static const _monthLabels = ['1', '5', '10', '15', '20', '25', '30'];

  @override
  Widget build(BuildContext context) {
    final labels = monthly ? _monthLabels : _weekLabels;
    final desc = [
      for (var i = 0; i < values.length && i < labels.length; i++) '${labels[i]} ${values[i]}%'
    ].join(', ');
    return Semantics(
      label: '${monthly ? 'Сарын' : 'Долоо хоногийн'} ахиц: $desc',
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 300 / 126,
            child: CustomPaint(painter: _AreaPainter(values, color)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final l in labels)
                Text(l,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  _AreaPainter(this.values, this.color);
  final List<int> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // 300×126 viewBox-оор тооцоод бодит хэмжээ рүү масштаблана.
    canvas.save();
    canvas.scale(size.width / 300, size.height / 126);

    final grid = Paint()
      ..color = const Color(0xFFD5DEF2)
      ..strokeWidth = 1;
    for (final y in [20.0, 52.0, 84.0, 117.0]) {
      for (double x = 8; x < 292; x += 8) {
        canvas.drawLine(Offset(x, y), Offset(math.min(x + 3, 292), y), grid);
      }
    }

    final g = chartGeometry(values);
    if (g.points.isEmpty) {
      canvas.restore();
      return;
    }
    final line = Path()..moveTo(g.points.first.dx, g.points.first.dy);
    for (final s in g.segments) {
      line.cubicTo(s.c1.dx, s.c1.dy, s.c2.dx, s.c2.dy, s.end.dx, s.end.dy);
    }
    final area = Path.from(line)
      ..lineTo(g.points.last.dx, g.baseline)
      ..lineTo(g.points.first.dx, g.baseline)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: .19), color.withValues(alpha: .015)],
        ).createShader(const Rect.fromLTWH(0, 0, 300, 126)),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round,
    );
    final end = g.points.last;
    canvas.drawCircle(end, 6, Paint()..color = Colors.white);
    canvas.drawCircle(end, 4.5, Paint()..color = color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AreaPainter old) => old.values != values || old.color != color;
}

const donutColors = [AppColors.blue, AppColors.teal, AppColors.violet, AppColors.orange];

class DonutChart extends StatelessWidget {
  const DonutChart({super.key, required this.skills, this.size = 132});

  final List<Skill> skills;
  final double size;

  @override
  Widget build(BuildContext context) {
    final total = skills.fold<int>(0, (s, k) => s + k.progress);
    final average = skills.isEmpty ? 0 : (total / skills.length).round();
    return Semantics(
      label: 'Чиглэлүүдийн дундаж ахиц $average%',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _DonutPainter(skills.map((s) => s.progress).toList()),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(TextSpan(
                  text: '$average',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -1),
                  children: const [
                    TextSpan(
                        text: '%',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                  ],
                )),
                const Text('дундаж ахиц',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.values);
  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final scale = size.width / 112;
    final r = 44 * scale;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * scale;
    canvas.drawArc(rect, 0, math.pi * 2, false, base..color = const Color(0xFFE6EDFD));

    final total = values.fold<int>(0, (s, v) => s + v);
    final circumference = 2 * math.pi * r;
    final gap = 6 * scale / r; // ~6px зай (радианаар)
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = total == 0 ? math.pi / 2 : values[i] / total * math.pi * 2;
      final visible = math.max(0.0, sweep - gap);
      if (visible > 0 && circumference > 0) {
        canvas.drawArc(
          rect,
          start,
          visible,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke * scale
            ..strokeCap = StrokeCap.round
            ..color = donutColors[i % donutColors.length],
        );
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.values != values;
}
