import 'dart:math';

import '../models/entities.dart';

DateTime normalizeDate(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime addYearsClamped(DateTime value, int years) {
  final normalized = normalizeDate(value);
  final targetYear = normalized.year + years;
  final maxDay = DateTime(targetYear, normalized.month + 1, 0).day;
  return DateTime(targetYear, normalized.month, min(normalized.day, maxDay));
}

int daysInLifeYear(DateTime birthDate, int yearOffset) {
  final start = addYearsClamped(birthDate, yearOffset);
  final end = addYearsClamped(birthDate, yearOffset + 1);
  return end.difference(start).inDays;
}

int lifeYearChunkSize(int yearDotRows) {
  final rows = yearDotRows.clamp(2, 6);
  return (366 / rows).ceil();
}

List<int> distributeLifeYearDays({
  required int daysInYear,
  required int yearDotRows,
}) {
  final safeDays = daysInYear.clamp(0, 366);
  final chunkSize = lifeYearChunkSize(yearDotRows);
  final rows = yearDotRows.clamp(2, 6);
  return List<int>.generate(rows, (row) {
    final rowStart = row * chunkSize;
    final remaining = safeDays - rowStart;
    if (remaining <= 0) {
      return 0;
    }
    return min(chunkSize, remaining);
  }, growable: false);
}

int calculateAgeYears(DateTime birthDate, DateTime today) {
  final birth = normalizeDate(birthDate);
  final now = normalizeDate(today);
  var years = now.year - birth.year;
  final birthdayThisYear = addYearsClamped(birth, years);
  if (now.isBefore(birthdayThisYear)) {
    years -= 1;
  }
  return max(0, years);
}

LifeGridStats calculateLifeGridStats({
  required DateTime birthDate,
  required int lifespanYears,
  DateTime? now,
}) {
  final birth = normalizeDate(birthDate);
  final today = normalizeDate(now ?? DateTime.now());
  final lifespanEndExclusive = addYearsClamped(birth, lifespanYears);
  final totalDays = lifespanEndExclusive.difference(birth).inDays;

  final livedRaw = today.isBefore(birth)
      ? 0
      : today.difference(birth).inDays + 1;
  final livedDays = livedRaw.clamp(0, totalDays);
  final remainingDays = totalDays - livedDays;
  final ageYears = calculateAgeYears(birth, today).clamp(0, lifespanYears);

  return LifeGridStats(
    ageYears: ageYears,
    livedDays: livedDays,
    remainingDays: remainingDays,
    totalDays: totalDays,
    endDate: lifespanEndExclusive.subtract(const Duration(days: 1)),
  );
}

DateTime dayAtOffset(DateTime yearStart, int dayOffset) {
  return yearStart.add(Duration(days: dayOffset));
}
