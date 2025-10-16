import 'package:flutter/foundation.dart';
import '../models/course.dart';

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [];

  List<Course> get courses => List.unmodifiable(_courses);

  void addCourse(Course c) {
    _courses.add(c);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      notifyListeners();
    }
  }

  double get totalCredits => _courses.fold<double>(0.0, (double s, Course c) => s + c.credits);

  double get cgpa {
    final totalWeighted = _courses.fold<double>(0.0, (double s, Course c) => s + (c.credits * c.point));
    if (totalCredits == 0) return 0.0;
    return totalWeighted / totalCredits;
  }
}
