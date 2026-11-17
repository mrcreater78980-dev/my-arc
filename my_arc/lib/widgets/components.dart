// components.tsx → Flutter
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/data.dart';
import '../theme.dart';

TextStyle _t(double size, {FontWeight weight = FontWeight.w600, Color? color, double? ls}) =>
    TextStyle(fontSize: size, fontWeight: weight, color: color, letterSpacing: ls);

// ---------------------------------------------------------------- GlassCard
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .7),
        borderRadius: radius,
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: .08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- ProgressBar
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.color = 'blue', this.height = 7});

  final num value;
  final String color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = Accent.of(color);
    return Semantics(
      label: 'Ахиц',
      value: '${value.round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: height,
          color: AppColors.track,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (value / 100).clamp(0, 1).toDouble(),
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [accent.light, accent.main]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- ProgressRing
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 76,
    this.stroke = 6,
    this.color = 'blue',
    this.child,
  });

  final num value;
  final double size;
  final double stroke;
  final String color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final accent = Accent.of(color);
    return Semantics(
      label: '${value.round()}%',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            value: value.toDouble(),
            stroke: stroke,
            color: accent.main,
            track: accent.soft,
          ),
          child: Center(
            child: child ??
                Text.rich(
                  TextSpan(
                    text: '${value.round()}',
                    style: _t(size * .24, weight: FontWeight.w800),
                    children: [
                      TextSpan(text: '%', style: _t(size * .14, color: AppColors.secondary)),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.stroke, required this.color, required this.track});

  final double value;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final deflated = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(deflated, 0, math.pi * 2, false, base..color = track);
    final sweep = (value.clamp(0, 100) / 100) * math.pi * 2;
    if (sweep > 0) {
      canvas.drawArc(
        deflated,
        -math.pi / 2,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.stroke != stroke;
}

// ---------------------------------------------------------------- MiniBarChart
class MiniBarChart extends StatelessWidget {
  const MiniBarChart({super.key, required this.bars, this.color = 'blue', this.height = 30});

  final List<int> bars;
  final String color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = Accent.of(color);
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < bars.length; i++)
              Container(
                width: 5,
                height: height * bars[i] / 100,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: i == bars.length - 1
                      ? accent.barLast
                      : ((i + 1) % 3 == 0 ? accent.barAlt : accent.bar),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Icons
const Map<String, IconData> skillIcons = {
  'code': Icons.code_rounded,
  'network': Icons.account_tree_outlined,
  'globe': Icons.language_rounded,
  'phone': Icons.smartphone_rounded,
  'database': Icons.storage_rounded,
  'git': Icons.call_split_rounded,
  'server': Icons.dns_outlined,
  'layers': Icons.layers_outlined,
  'bug': Icons.bug_report_outlined,
  'book': Icons.menu_book_outlined,
};

class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, this.color = 'blue', this.size = 19, this.box = 38});

  final IconData icon;
  final String color;
  final double size;
  final double box;

  @override
  Widget build(BuildContext context) {
    final accent = Accent.of(color);
    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(color: accent.soft, borderRadius: BorderRadius.circular(box * .32)),
      child: Icon(icon, size: size, color: accent.main),
    );
  }
}

class SkillIcon extends StatelessWidget {
  const SkillIcon({super.key, required this.skill, this.size = 19});

  final Skill skill;
  final double size;

  @override
  Widget build(BuildContext context) =>
      IconBadge(icon: skillIcons[skill.icon] ?? Icons.code_rounded, color: skill.color, size: size);
}

// ---------------------------------------------------------------- Positive change
class PositiveChange extends StatelessWidget {
  const PositiveChange(this.text, {super.key, this.size = 11, this.showArrow = true});

  final String text;
  final double size;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showArrow) Icon(Icons.north_east_rounded, size: size + 2, color: AppColors.positive),
        Text(text, style: _t(size, weight: FontWeight.w700, color: AppColors.positive)),
      ],
    );
  }
}

// ---------------------------------------------------------------- SkillCard
class SkillCard extends StatelessWidget {
  const SkillCard({super.key, required this.skill, required this.onTap});

  final Skill skill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${skill.title}, ${skill.progress}%, Түвшин ${skill.level}',
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkillIcon(skill: skill),
                ProgressRing(value: skill.progress, size: 43, stroke: 3, color: skill.color),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              skill.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _t(13, weight: FontWeight.w700, ls: -.2).copyWith(height: 1.3),
            ),
            if (skill.technology != null)
              Text(skill.technology!, style: _t(10, color: AppColors.muted)),
            const Spacer(),
            Text('Түвшин ${skill.level}', style: _t(10, color: AppColors.secondary)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MiniBarChart(bars: skill.bars, color: skill.color, height: 26),
                PositiveChange('+${skill.change}%', size: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Checkbox + ListRow
class CircularCheckbox extends StatelessWidget {
  const CircularCheckbox({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.label,
    this.size = 23,
  });

  final bool checked;
  final VoidCallback onChanged;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: checked,
      label: label,
      child: InkResponse(
        onTap: onChanged,
        radius: size,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: checked ? AppColors.blue : Colors.transparent,
            border: Border.all(
              color: checked ? AppColors.blue : AppColors.checkboxBorder,
              width: 1.5,
            ),
            boxShadow: checked
                ? [BoxShadow(color: AppColors.blue.withValues(alpha: .13), blurRadius: 7, offset: const Offset(0, 2))]
                : null,
          ),
          child: checked ? Icon(Icons.check_rounded, size: size * .62, color: Colors.white) : null,
        ),
      ),
    );
  }
}

class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.title,
    required this.checked,
    required this.onChanged,
    this.trailing,
    this.subtitle,
    this.large = false,
  });

  final String title;
  final bool checked;
  final VoidCallback onChanged;
  final Widget? trailing;
  final String? subtitle;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: large ? 12 : 9),
      child: Row(
        children: [
          CircularCheckbox(checked: checked, onChanged: onChanged, label: title, size: large ? 25 : 23),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _t(large ? 14 : 13, color: checked ? AppColors.faint : AppColors.navy).copyWith(
                    decoration: checked ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.faint,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle!, style: _t(11, weight: FontWeight.w500, color: AppColors.muted)),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

class TimeLabel extends StatelessWidget {
  const TimeLabel(this.time, {super.key});
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.schedule_rounded, size: 13, color: AppColors.muted),
        const SizedBox(width: 4),
        Text(time ?? '', style: _t(11, color: AppColors.secondary)),
      ],
    );
  }
}

// ---------------------------------------------------------------- Streak
class Streak extends StatelessWidget {
  const Streak({super.key, required this.days, this.pill = false, this.label = 'өдөр'});

  final int days;
  final bool pill;
  final String label;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.orange),
        const SizedBox(width: 4),
        Text('$days $label', style: _t(10.5, color: AppColors.orange)),
      ],
    );
    if (!pill) return content;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DF).withValues(alpha: .7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: content,
    );
  }
}

// ---------------------------------------------------------------- Headings & chips
class CountChip extends StatelessWidget {
  const CountChip(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EEFF).withValues(alpha: .7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: _t(10, weight: FontWeight.w700, color: AppColors.blue)),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.link, this.onTap, this.count});

  final String title;
  final String? link;
  final VoidCallback? onTap;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(title, style: _t(16, weight: FontWeight.w800, ls: -.4)),
          if (count != null) ...[const SizedBox(width: 8), CountChip(count!)],
          const Spacer(),
          if (link != null)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    Text(link!, style: _t(12, weight: FontWeight.w700, color: AppColors.blue)),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.blue),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Overline extends StatelessWidget {
  const Overline(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: _t(9, weight: FontWeight.w800, color: const Color(0xFF90A0BA), ls: 1.3));
}

class SmallDot extends StatelessWidget {
  const SmallDot({super.key, this.color = const Color(0xFF9CADCC)});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class BottomNote extends StatelessWidget {
  const BottomNote({super.key, required this.text, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 13, color: AppColors.faint)
          else
            const SmallDot(),
          const SizedBox(width: 8),
          Flexible(
            child: Text(text, textAlign: TextAlign.center, style: _t(11, weight: FontWeight.w500, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Buttons
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expand = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 19) : const SizedBox.shrink(),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        disabledBackgroundColor: const Color(0xFFB9C9EF),
        disabledForegroundColor: Colors.white,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: _t(14, weight: FontWeight.w700),
        elevation: 0,
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

// ---------------------------------------------------------------- StatCard
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.unit,
    this.change,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final String? change;
  final String color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: icon, color: color, size: 18, box: 34),
          const SizedBox(height: 10),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: _t(10.5, color: AppColors.secondary)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(TextSpan(
                    text: value,
                    style: _t(20, weight: FontWeight.w800, ls: -.6),
                    children: [
                      if (unit != null)
                        TextSpan(text: unit, style: _t(11, color: AppColors.muted)),
                    ],
                  )),
                ),
              ),
              if (change != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: PositiveChange(change!, size: 10, showArrow: false),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Нэг мөрөнд 3 StatCard.
class ThreeStats extends StatelessWidget {
  const ThreeStats({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          IconBadge(icon: icon, size: 30, box: 60),
          const SizedBox(height: 12),
          Text(title, style: _t(15, weight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center, style: _t(12, weight: FontWeight.w500, color: AppColors.secondary)),
        ],
      ),
    );
  }
}

/// Шүүлтүүрийн таб (Өнөөдөр / Төлөвлөсөн / Дууссан, 7 хоног / Сар)
class FilterTabs<T> extends StatelessWidget {
  const FilterTabs({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
    this.badge,
  });

  final List<(T, String)> items;
  final T selected;
  final ValueChanged<T> onSelect;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .44),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (id, label) in items)
            Semantics(
              selected: id == selected,
              button: true,
              child: GestureDetector(
                onTap: () => onSelect(id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: id == selected ? AppColors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: _t(12, weight: FontWeight.w700, color: id == selected ? Colors.white : AppColors.secondary),
                      ),
                      if (id == selected && badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .24),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(badge!, style: _t(10, weight: FontWeight.w800, color: Colors.white)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Хоёр багана (өргөн дэлгэц) эсвэл нэг багана (утас).
class ResponsivePair extends StatelessWidget {
  const ResponsivePair({super.key, required this.first, required this.second, this.breakpoint = 720});
  final Widget first;
  final Widget second;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= breakpoint) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: first), const SizedBox(width: 20), Expanded(child: second)],
        );
      }
      return Column(children: [first, const SizedBox(height: 20), second]);
    });
  }
}
