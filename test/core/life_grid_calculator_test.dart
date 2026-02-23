import 'package:calculated_life/core/date/life_grid_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('addYearsClamped clamps Feb 29 to Feb 28 in non-leap years', () {
    final birth = DateTime(2000, 2, 29);

    final afterOneYear = addYearsClamped(birth, 1);
    final afterFourYears = addYearsClamped(birth, 4);

    expect(afterOneYear, DateTime(2001, 2, 28));
    expect(afterFourYears, DateTime(2004, 2, 29));
  });

  test(
    'calculateLifeGridStats computes lived and remaining days with clamp',
    () {
      final stats = calculateLifeGridStats(
        birthDate: DateTime(2000, 1, 1),
        lifespanYears: 80,
        now: DateTime(2000, 1, 10),
      );

      expect(stats.livedDays, 10);
      expect(stats.totalDays, greaterThan(29000));
      expect(stats.remainingDays, stats.totalDays - 10);
    },
  );

  test('future birth date returns zero lived days', () {
    final stats = calculateLifeGridStats(
      birthDate: DateTime(2030, 1, 1),
      lifespanYears: 80,
      now: DateTime(2026, 1, 1),
    );

    expect(stats.livedDays, 0);
    expect(stats.remainingDays, stats.totalDays);
  });

  test(
    'distributeLifeYearDays supports 2..6 rows with leap-year-safe output',
    () {
      for (var rows = 2; rows <= 6; rows++) {
        final leap = distributeLifeYearDays(daysInYear: 366, yearDotRows: rows);
        final nonLeap = distributeLifeYearDays(
          daysInYear: 365,
          yearDotRows: rows,
        );

        expect(leap.length, rows);
        expect(nonLeap.length, rows);
        expect(leap.reduce((a, b) => a + b), 366);
        expect(nonLeap.reduce((a, b) => a + b), 365);
        expect(leap.every((value) => value >= 0), isTrue);
        expect(nonLeap.every((value) => value >= 0), isTrue);
      }

      expect(distributeLifeYearDays(daysInYear: 366, yearDotRows: 4), [
        92,
        92,
        92,
        90,
      ]);
    },
  );
}
