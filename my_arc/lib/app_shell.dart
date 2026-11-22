// App.tsx → үндсэн хүрээ: брэнд мөр, гарчиг, 5 хуудас, доод цэс, FAB, нэмэх sheet
import 'package:flutter/material.dart';

import 'models/data.dart';
import 'screens/habits_screen.dart';
import 'screens/home_screen.dart';
import 'screens/navigation.dart';
import 'screens/progress_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/tasks_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';
import 'widgets/layout.dart';

class _NavItem {
  final AppPage id;
  final String title;
  final IconData icon;
  final IconData activeIcon;
  const _NavItem(this.id, this.title, this.icon, this.activeIcon);
}

const _navigation = [
  _NavItem(AppPage.home, 'Нүүр', Icons.home_outlined, Icons.home_rounded),
  _NavItem(AppPage.tasks, 'Ажил', Icons.checklist_rounded, Icons.checklist_rounded),
  _NavItem(AppPage.habits, 'Дадал', Icons.local_florist_outlined, Icons.local_florist),
  _NavItem(AppPage.skills, 'Ур чадвар', Icons.layers_outlined, Icons.layers_rounded),
  _NavItem(AppPage.progress, 'Явц', Icons.insights_rounded, Icons.insights_rounded),
];

const _subtitles = {
  AppPage.home: 'Сайн уу, Бат!',
  AppPage.tasks: 'Жижиг алхам. Том өөрчлөлт.',
  AppPage.habits: 'Тууштай байдал амжилтыг бүтээнэ.',
  AppPage.skills: 'Өнөөдөр сур. Маргааш бүтээ.',
  AppPage.progress: 'Өчигдрийн өөрөөсөө нэг алхам урагш.',
};

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppPage _page = AppPage.home;

  void _navigate(AppPage next) => setState(() => _page = next);

  Future<void> _addTask() async {
    final title = await showAddSheet(
      context,
      title: 'Ажил нэмэх',
      label: 'Ажлын нэр',
      hint: 'Юу хийхээр төлөвлөж байна?',
    );
    if (title != null && mounted) AppScope.of(context).addTask(title);
  }

  Future<void> _addHabit() async {
    final title = await showAddSheet(
      context,
      title: 'Дадал нэмэх',
      label: 'Дадлын нэр',
      hint: 'Ямар дадал бий болгох вэ?',
    );
    if (title != null && mounted) AppScope.of(context).addHabit(title);
  }

  Widget _pageBody() {
    switch (_page) {
      case AppPage.home:
        return HomeScreen(onNavigate: _navigate);
      case AppPage.tasks:
        return const TasksScreen();
      case AppPage.habits:
        return HabitsScreen(onAdd: _addHabit);
      case AppPage.skills:
        return const SkillsScreen();
      case AppPage.progress:
        return const ProgressScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = _navigation.firstWhere((n) => n.id == _page);
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BrandBar(onHome: () => _navigate(AppPage.home)),
              Expanded(
                child: PageBody(
                  key: PageStorageKey(_page),
                  children: [
                    PageHeader(
                      eyebrow: _page == AppPage.home ? 'ТАНЫ ӨСӨЛТИЙН ОРОН ЗАЙ' : 'ӨДӨР БҮР, НЭГ АЛХАМ УРАГШ',
                      title: nav.title,
                      subtitle: _page == AppPage.home
                          ? 'Сайн уу, ${AppScope.of(context).profileName}!'
                          : _subtitles[_page]!,
                      onSettings: () => openSettings(context),
                    ),
                    _pageBody(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _page == AppPage.tasks
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FloatingActionButton(
                  tooltip: 'Ажил нэмэх',
                  onPressed: _addTask,
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.add_rounded, size: 28),
                ),
              )
            : null,
        bottomNavigationBar: _BottomNav(current: _page, onSelect: _navigate),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect});
  final AppPage current;
  final ValueChanged<AppPage> onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(color: AppColors.blue.withValues(alpha: .12), blurRadius: 30, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: [
              for (final item in _navigation)
                Expanded(
                  child: Semantics(
                    selected: item.id == current,
                    button: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => onSelect(item.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: item.id == current ? const Color(0xFFE5EDFF) : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                item.id == current ? item.activeIcon : item.icon,
                                size: 21,
                                color: item.id == current ? AppColors.blue : AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: item.id == current ? FontWeight.w800 : FontWeight.w600,
                                color: item.id == current ? AppColors.blue : AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
