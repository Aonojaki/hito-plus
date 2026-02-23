import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../core/date/life_grid_calculator.dart';
import '../../core/models/entities.dart';
import '../../core/providers.dart';
import '../../core/repositories/interfaces.dart';
import '../../core/widgets/outlined_panel.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final TextEditingController _lifespanController = TextEditingController(
    text: '80',
  );

  DateTime _birthDate = DateTime(2000, 1, 1);
  int _yearDotRows = 4;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _repo.getSettings();
      if (!mounted) {
        return;
      }
      setState(() {
        _birthDate = normalizeDate(settings.birthDate);
        _lifespanController.text = settings.lifespanYears.toString();
        _yearDotRows = settings.yearDotRows.clamp(2, 6);
        _isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = 'Failed to load calendar settings.';
      });
    }
  }

  int get _lifespanYears {
    final parsed = int.tryParse(_lifespanController.text.trim());
    if (parsed == null || parsed <= 0) {
      return 80;
    }
    return parsed;
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      initialDate: _birthDate,
    );
    if (picked != null) {
      setState(() {
        _birthDate = normalizeDate(picked);
        _error = null;
      });
    }
  }

  Future<void> _save() async {
    final lifespan = int.tryParse(_lifespanController.text.trim());
    final today = normalizeDate(DateTime.now());
    final birth = normalizeDate(_birthDate);

    if (lifespan == null || lifespan <= 0 || lifespan > 150) {
      setState(() {
        _error = 'Lifespan must be a number between 1 and 150.';
      });
      return;
    }

    if (birth.isAfter(today)) {
      setState(() {
        _error = 'Birth date cannot be in the future.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      final existing = await _repo.getSettings();
      await _repo.updateSettings(
        AppSettings(
          birthDate: birth,
          lifespanYears: lifespan,
          yearDotRows: _yearDotRows,
          notebookAiAccessEnabled: existing.notebookAiAccessEnabled,
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calendar settings updated.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Could not save settings.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _lifespanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final stats = calculateLifeGridStats(
      birthDate: _birthDate,
      lifespanYears: _lifespanYears,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _pickBirthDate,
              child: Text(
                'Birth Date: ${DateFormat('dd MMM yyyy').format(_birthDate)}',
              ),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                controller: _lifespanController,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Lifespan Years'),
              ),
            ),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
            Text(
              'End: ${DateFormat('dd MMM yyyy').format(stats.endDate)}',
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rows/Year: $_yearDotRows',
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _error!,
              style: const TextStyle(
                color: AppTheme.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        OutlinedPanel(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          backgroundColor: AppTheme.panel,
          borderWidth: 1.8,
          child: Wrap(
            spacing: 18,
            runSpacing: 6,
            children: [
              _Stat(label: 'Years Passed', value: stats.ageYears.toString()),
              _Stat(label: 'Days Lived', value: stats.livedDays.toString()),
              _Stat(label: 'Days Left', value: stats.remainingDays.toString()),
              _Stat(label: 'Total Days', value: stats.totalDays.toString()),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Life map: black dots are passed days ($_yearDotRows lines per year).',
          style: const TextStyle(
            fontFamily: 'Consolas',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _LifeGrid(
            birthDate: _birthDate,
            lifespanYears: _lifespanYears,
            yearDotRows: _yearDotRows,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontFamily: 'Consolas', fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Consolas',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LifeGrid extends StatefulWidget {
  const _LifeGrid({
    required this.birthDate,
    required this.lifespanYears,
    required this.yearDotRows,
  });

  final DateTime birthDate;
  final int lifespanYears;
  final int yearDotRows;

  @override
  State<_LifeGrid> createState() => _LifeGridState();
}

class _LifeGridState extends State<_LifeGrid> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = normalizeDate(DateTime.now());
    final years = widget.lifespanYears.clamp(1, 200);
    final gridWidth =
        _YearDotsBlock.gridWidthForRows(widget.yearDotRows) +
        _LifeYearBlock.labelWidth +
        12;

    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      notificationPredicate: (notification) => notification.depth == 0,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: gridWidth,
          child: Scrollbar(
            controller: _verticalController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _verticalController,
              itemCount: years,
              itemExtent: _LifeYearBlock.blockHeightForRows(widget.yearDotRows),
              cacheExtent: 1000,
              itemBuilder: (context, yearIndex) {
                return RepaintBoundary(
                  child: _LifeYearBlock(
                    birthDate: widget.birthDate,
                    yearIndex: yearIndex,
                    today: today,
                    yearDotRows: widget.yearDotRows,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LifeYearBlock extends StatelessWidget {
  const _LifeYearBlock({
    required this.birthDate,
    required this.yearIndex,
    required this.today,
    required this.yearDotRows,
  });

  static const double labelWidth = 42;

  final DateTime birthDate;
  final int yearIndex;
  final DateTime today;
  final int yearDotRows;

  static double blockHeightForRows(int rows) {
    return _YearDotsBlock.gridHeightForRows(rows) + 6;
  }

  @override
  Widget build(BuildContext context) {
    final yearStart = addYearsClamped(birthDate, yearIndex);
    final daysInYear = daysInLifeYear(birthDate, yearIndex);

    return SizedBox(
      height: blockHeightForRows(yearDotRows),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SizedBox(
              width: labelWidth,
              child: Text(
                'Y${(yearIndex + 1).toString().padLeft(2, '0')}',
                style: const TextStyle(fontFamily: 'Consolas', fontSize: 11),
              ),
            ),
          ),
          _YearDotsBlock(
            birthDate: birthDate,
            yearStart: yearStart,
            today: today,
            daysInYear: daysInYear,
            yearDotRows: yearDotRows,
          ),
        ],
      ),
    );
  }
}

class _YearDotsBlock extends StatefulWidget {
  const _YearDotsBlock({
    required this.birthDate,
    required this.yearStart,
    required this.today,
    required this.daysInYear,
    required this.yearDotRows,
  });

  static const double dotSpacing = 8;
  static const double dotRadius = 2.8;
  static const double rowHeight = 10;

  final DateTime birthDate;
  final DateTime yearStart;
  final DateTime today;
  final int daysInYear;
  final int yearDotRows;

  static int chunkSizeForRows(int rows) {
    return lifeYearChunkSize(rows);
  }

  static double gridWidthForRows(int rows) {
    return chunkSizeForRows(rows) * dotSpacing;
  }

  static double gridHeightForRows(int rows) {
    return rows * rowHeight;
  }

  @override
  State<_YearDotsBlock> createState() => _YearDotsBlockState();
}

class _YearDotsBlockState extends State<_YearDotsBlock> {
  static final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  int? _hoveredDayIndex;

  int _calculateLivedCount() {
    final yearEndExclusive = widget.yearStart.add(
      Duration(days: widget.daysInYear),
    );

    if (widget.today.isBefore(widget.yearStart)) {
      return 0;
    }
    if (!widget.today.isBefore(yearEndExclusive)) {
      return widget.daysInYear;
    }
    return widget.today.difference(widget.yearStart).inDays + 1;
  }

  void _onHover(PointerHoverEvent event) {
    final chunkSize = _YearDotsBlock.chunkSizeForRows(widget.yearDotRows);
    final col = (event.localPosition.dx / _YearDotsBlock.dotSpacing).floor();
    final row = (event.localPosition.dy / _YearDotsBlock.rowHeight).floor();

    int? nextIndex;
    if (row >= 0 && row < widget.yearDotRows && col >= 0 && col < chunkSize) {
      final candidate = row * chunkSize + col;
      if (candidate >= 0 && candidate < widget.daysInYear) {
        nextIndex = candidate;
      }
    }

    if (nextIndex != _hoveredDayIndex) {
      setState(() {
        _hoveredDayIndex = nextIndex;
      });
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_hoveredDayIndex != null) {
      setState(() {
        _hoveredDayIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chunkSize = _YearDotsBlock.chunkSizeForRows(widget.yearDotRows);
    final livedCount = _calculateLivedCount();

    DateTime? hoveredDate;
    int? hoveredDayCount;
    if (_hoveredDayIndex != null) {
      hoveredDate = dayAtOffset(widget.yearStart, _hoveredDayIndex!);
      hoveredDayCount =
          hoveredDate.difference(normalizeDate(widget.birthDate)).inDays + 1;
    }

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: _YearDotsBlock.gridWidthForRows(widget.yearDotRows),
            height: _YearDotsBlock.gridHeightForRows(widget.yearDotRows),
            child: CustomPaint(
              painter: _YearDotsBlockPainter(
                daysInYear: widget.daysInYear,
                livedCount: livedCount,
                yearDotRows: widget.yearDotRows,
              ),
            ),
          ),
          if (_hoveredDayIndex != null &&
              hoveredDate != null &&
              hoveredDayCount != null)
            Positioned(
              left: (_hoveredDayIndex! % chunkSize) * _YearDotsBlock.dotSpacing,
              top: -30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.paper,
                  borderRadius: AppTheme.borderRadiusSm,
                  border: Border.all(color: AppTheme.ink, width: 1.2),
                ),
                child: Text(
                  '${_dateFormatter.format(hoveredDate)} - Day $hoveredDayCount',
                  style: const TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _YearDotsBlockPainter extends CustomPainter {
  _YearDotsBlockPainter({
    required this.daysInYear,
    required this.livedCount,
    required this.yearDotRows,
  });

  final int daysInYear;
  final int livedCount;
  final int yearDotRows;

  @override
  void paint(Canvas canvas, Size size) {
    final chunkSize = _YearDotsBlock.chunkSizeForRows(yearDotRows);

    final livedPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.ink;

    final futurePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.paper;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.85
      ..color = AppTheme.ink;

    for (var day = 0; day < daysInYear; day++) {
      final row = day ~/ chunkSize;
      final col = day % chunkSize;
      final centerX =
          col * _YearDotsBlock.dotSpacing + (_YearDotsBlock.dotSpacing / 2);
      final centerY =
          row * _YearDotsBlock.rowHeight + (_YearDotsBlock.rowHeight / 2);
      final center = Offset(centerX, centerY);

      canvas.drawCircle(
        center,
        _YearDotsBlock.dotRadius,
        day < livedCount ? livedPaint : futurePaint,
      );
      canvas.drawCircle(center, _YearDotsBlock.dotRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _YearDotsBlockPainter oldDelegate) {
    return oldDelegate.daysInYear != daysInYear ||
        oldDelegate.livedCount != livedCount ||
        oldDelegate.yearDotRows != yearDotRows;
  }
}
