import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// index.css-ийн өнгөнүүд
class AppColors {
  static const blue = Color(0xFF2F6BFF);
  static const teal = Color(0xFF19BCA8);
  static const violet = Color(0xFF7C5CFF);
  static const orange = Color(0xFFEC9946);
  static const navy = Color(0xFF14213D);
  static const secondary = Color(0xFF6B7A99);
  static const muted = Color(0xFF8B99B5);
  static const faint = Color(0xFF9CADCC);
  static const track = Color(0xFFE3EAFB);
  static const checkboxBorder = Color(0xFFC8D4ED);
  static const positive = Color(0xFF22B573);

  static const background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8EFFF), Color(0xFFEFF1FC), Color(0xFFF4F0FF)],
    stops: [0, .48, 1],
  );
}

/// skill.color ("blue" | "violet" | "teal" | "orange" | "neutral") → өнгөний багц
class Accent {
  final Color main;
  final Color soft; // icon-badge дэвсгэр
  final Color light; // progress gradient эхлэл
  final Color bar; // mini-chart багана
  final Color barAlt; // 3n багана
  final Color barLast; // сүүлийн багана

  const Accent(this.main, this.soft, this.light, this.bar, this.barAlt, this.barLast);

  static const _blue = Accent(AppColors.blue, Color(0xFFE5EDFF), Color(0xFF7198FF),
      Color(0xFFA4BDFF), Color(0xFFCCDAFF), Color(0xFF7298FC));
  static const _violet = Accent(AppColors.violet, Color(0xFFECE7FF), Color(0xFFAE98FF),
      Color(0xFFC4B4F7), Color(0xFFDDD2FA), Color(0xFFA08AE9));
  static const _teal = Accent(AppColors.teal, Color(0xFFE0F5F1), Color(0xFF62D9CA),
      Color(0xFF99DED3), Color(0xFFC4EBE4), Color(0xFF70CBB9));
  static const _orange = Accent(AppColors.orange, Color(0xFFFFF0DE), Color(0xFFF5BE85),
      Color(0xFFF5C99A), Color(0xFFFADDBE), Color(0xFFEC9946));
  static const _neutral = Accent(AppColors.secondary, Color(0xFFEEF1F7), Color(0xFFB4BED3),
      Color(0xFFCDD5E4), Color(0xFFE1E6EF), Color(0xFF9CADCC));

  static Accent of(String color) {
    switch (color) {
      case 'violet':
        return _violet;
      case 'teal':
        return _teal;
      case 'orange':
        return _orange;
      case 'neutral':
        return _neutral;
      default:
        return _blue;
    }
  }
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue, primary: AppColors.blue),
    scaffoldBackgroundColor: Colors.transparent,
  );
  return base.copyWith(
    textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
      bodyColor: AppColors.navy,
      displayColor: AppColors.navy,
    ),
  );
}
