class Course {
  String name;
  double credits;
  // New: components of marks
  double finalMarks; // out of 50
  double midMarks; // out of 25
  List<double> assignments; // 4 items, collectively 12.5 (each 2.5)
  List<double> quizzes; // 4 items, collectively 12.5 (each 2.5)

  Course({
    required this.name,
    required this.credits,
    required this.finalMarks,
    required this.midMarks,
    required this.assignments,
    required this.quizzes,
  });

  // Totals computed with explicit types to avoid inference issues
  double get assignmentsTotal => assignments.fold<double>(0.0, (double s, double v) => s + v);
  double get quizzesTotal => quizzes.fold<double>(0.0, (double s, double v) => s + v);

  // Total should sum to 100 (50 + 25 + 12.5 + 12.5)
  double get totalMarks => (finalMarks + midMarks + assignmentsTotal + quizzesTotal);

  bool get isFail => totalMarks < 50.0;

  // Map total marks to subject grade point according to rules:
  // <50 => fail (0.0)
  // 50-60 => 2.0 to 2.5
  // 60-70 => 2.5 to 3.0
  // 70-85 => 3.0 to 3.9
  // >=85 => 4.0
  double get point {
    return subjectPointFromMarks(totalMarks);
  }

  double subjectPointFromMarks(double m) {
    if (m < 50) return 0.0;
    if (m >= 85) return 4.0;

    // Helper linear interpolation
    double lerp(double a, double b, double t) => a + (b - a) * t;

    if (m >= 50 && m < 60) {
      final t = (m - 50) / 10.0; // 0..1
      return lerp(2.0, 2.5, t);
    }
    if (m >= 60 && m < 70) {
      final t = (m - 60) / 10.0;
      return lerp(2.5, 3.0, t);
    }
    // 70..85 maps to 3.0 .. 3.9
    if (m >= 70 && m < 85) {
      final t = (m - 70) / 15.0;
      return lerp(3.0, 3.9, t);
    }

    // fallback
    return 0.0;
  }
}
