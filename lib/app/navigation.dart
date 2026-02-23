class AppSection {
  const AppSection({
    required this.path,
    required this.label,
    required this.shortLabel,
  });

  final String path;
  final String label;
  final String shortLabel;
}

const List<AppSection> appSections = [
  AppSection(path: '/calendar', label: 'Calendar', shortLabel: 'cal'),
  AppSection(path: '/notebook', label: 'Notebook', shortLabel: 'notebook'),
  AppSection(
    path: '/vision-board',
    label: 'Vision Board',
    shortLabel: 'vision board',
  ),
  AppSection(path: '/planner', label: 'Planner', shortLabel: 'planner'),
  AppSection(path: '/scrapper', label: 'Scrapper', shortLabel: 'scrapper'),
  AppSection(path: '/ai-chat', label: 'AI Chat', shortLabel: 'ai chat'),
  AppSection(path: '/settings', label: 'Settings', shortLabel: 'settings'),
];
