# MY ARC — Flutter хувилбар

React + Vite (TypeScript) дээрх MY ARC аппын Flutter хөрвүүлэлт.

## Ажиллуулах

```bash
# 1. Шинэ Flutter төсөл үүсгээд (android/ios/web хавтас бий болгоно)
flutter create my_arc
# 2. Энэ архивын lib/, test/, pubspec.yaml, analysis_options.yaml-ийг тэр төсөл рүү хуулж солино
cd my_arc
flutter pub get
flutter run          # утас / эмулятор / chrome
flutter test         # data.test.ts-ийн Dart хувилбар
```

## Файлын харгалзаа

| React (src/)       | Flutter (lib/)                                  |
|--------------------|-------------------------------------------------|
| `data.ts`          | `models/data.dart`                              |
| `learning.ts`      | `models/learning.dart`                          |
| `App.tsx` (state)  | `state/app_state.dart` (ChangeNotifier + InheritedNotifier) |
| `App.tsx` (UI)     | `app_shell.dart`, `screens/home/tasks/habits_screen.dart` |
| `components.tsx`   | `widgets/components.dart`                       |
| `screens.tsx`      | `screens/*_screen.dart`, `widgets/charts.dart`  |
| `index.css`, `screens.css` | `theme.dart` (өнгө, Manrope фонт)       |
| `data.test.ts`     | `test/data_test.dart`                           |

* Нэмэлт багц: зөвхөн `google_fonts` (Manrope фонт).
* lucide-react дүрс тэмдгүүдийг Material Icons-оор орлуулсан.
* SVG график (AreaChart, DonutChart, ProgressRing) → `CustomPainter`.
* Дэлгэрэнгүй дэлгэцүүд (Чиглэл, Тохиргоо) `Navigator.push`-ээр нээгдэнэ — Android-ын буцах товч ажиллана.
