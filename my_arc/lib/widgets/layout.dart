// Бүх дэлгэцэд нийтлэг: дэвсгэр, брэнд мөр, гарчиг, буцах гарчиг, нэмэх sheet
import 'package:flutter/material.dart';

import '../theme.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: const BoxDecoration(gradient: AppColors.background), child: child);
}

/// Агуулгыг дунд нь, хамгийн их 1168px өргөнтэй байрлуулна.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.bottomPadding = 120});
  final List<Widget> children;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width >= 900 ? 48.0 : (width >= 600 ? 28.0 : 18.0);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(side, 20, side, bottomPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1168),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bar(double h, double o) => Transform.rotate(
          angle: .35,
          child: Container(
            width: 4,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: o),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
    return Transform.rotate(
      angle: -.07,
      child: Container(
        width: 33,
        height: 34,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [BoxShadow(color: AppColors.blue.withValues(alpha: .14), blurRadius: 12, offset: const Offset(0, 5))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [bar(9, .65), bar(14, .85), bar(20, 1)],
        ),
      ),
    );
  }
}

class BrandBar extends StatelessWidget {
  const BrandBar({super.key, required this.onHome});
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width >= 900 ? 48.0 : (width >= 600 ? 28.0 : 18.0);
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: side),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: .48))),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'MY ARC — Нүүр',
            child: GestureDetector(
              onTap: onHome,
              child: Row(
                children: [
                  const BrandMark(),
                  const SizedBox(width: 12),
                  Text.rich(
                    const TextSpan(
                      text: 'MY ARC',
                      children: [TextSpan(text: '.', style: TextStyle(color: AppColors.blue))],
                    ),
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -.8),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Flexible(
            child: Text(
              'Өдөр бүр, нэг алхам урагш.',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: Color(0xFF8491AC)),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onTap, required this.tooltip});
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: .44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Colors.white),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: SizedBox(width: 42, height: 42, child: Icon(icon, size: 19, color: AppColors.navy)),
        ),
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.onSettings,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eyebrow,
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.muted)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: wide ? 32 : 27, fontWeight: FontWeight.w800, letterSpacing: -1.2, height: 1.2)),
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(left: 4, bottom: 8),
                      decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.secondary)),
              ],
            ),
          ),
          if (wide) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .44),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.secondary),
                  SizedBox(width: 6),
                  Text('5 сарын 24, Баасан',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                ],
              ),
            ),
          ],
          RoundIconButton(icon: Icons.tune_rounded, tooltip: 'Тохиргоо', onTap: onSettings),
        ],
      ),
    );
  }
}

class BackHeader extends StatelessWidget {
  const BackHeader({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          RoundIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Буцах',
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -.8)),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// App.tsx доторх BottomSheet → showModalBottomSheet. Оруулсан нэрийг буцаана.
Future<String?> showAddSheet(
  BuildContext context, {
  required String title,
  required String label,
  required String hint,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (context) => _AddSheet(title: title, label: label, hint: hint),
  );
}

class _AddSheet extends StatefulWidget {
  const _AddSheet({required this.title, required this.label, required this.hint});
  final String title;
  final String label;
  final String hint;

  @override
  State<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<_AddSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 0, 22, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.6)),
            const SizedBox(height: 16),
            Text(widget.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _controller,
              autofocus: true,
              maxLength: 100,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Нэрээ оруулна уу' : null,
              decoration: InputDecoration(
                hintText: widget.hint,
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF3F6FD),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Нэмэх'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
