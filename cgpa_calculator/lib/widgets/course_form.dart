import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({Key? key}) : super(key: key);

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final _nameCtrl = TextEditingController();
  final _creditsCtrl = TextEditingController();
  final _finalCtrl = TextEditingController(); // out of 50
  final _midCtrl = TextEditingController(); // out of 25

  final List<TextEditingController> _assignmentCtrls = List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _quizCtrls = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    _nameCtrl.dispose();
    _creditsCtrl.dispose();
    _finalCtrl.dispose();
    _midCtrl.dispose();
    for (var c in _assignmentCtrls) c.dispose();
    for (var c in _quizCtrls) c.dispose();
    super.dispose();
  }

  double _parse(String s) {
    return double.tryParse(s.trim()) ?? 0.0;
  }

  // Validate ranges and prepare Course instance
  void _submit() {
    final name = _nameCtrl.text.trim();
    final credits = double.tryParse(_creditsCtrl.text) ?? 0.0;
    final finalMarks = _parse(_finalCtrl.text);
    final midMarks = _parse(_midCtrl.text);

    final assignments = _assignmentCtrls.map((c) => _parse(c.text)).toList();
    final quizzes = _quizCtrls.map((c) => _parse(c.text)).toList();

    // Build step-by-step alerts
    final List<String> steps = [];

    if (name.isEmpty) steps.add('Course name is required.');
    else steps.add('Course name: $name');

    if (credits <= 0) steps.add('Credits must be > 0.');
    else steps.add('Credits: ${credits.toStringAsFixed(2)}');

    // Validate component ranges
    if (finalMarks < 0 || finalMarks > 50) steps.add('Final marks must be between 0 and 50. (entered: $finalMarks)');
    else steps.add('Final: ${finalMarks.toStringAsFixed(2)} / 50');

    if (midMarks < 0 || midMarks > 25) steps.add('Mid marks must be between 0 and 25. (entered: $midMarks)');
    else steps.add('Mid: ${midMarks.toStringAsFixed(2)} / 25');

    bool assignmentsRangeOk = true;
    for (var i = 0; i < assignments.length; i++) {
      final v = assignments[i];
      if (v < 0 || v > 2.5) {
        assignmentsRangeOk = false;
        steps.add('Assignment ${i + 1} must be between 0 and 2.5. (entered: $v)');
      }
    }
    if (assignmentsRangeOk) steps.add('Assignments total: ${assignments.fold<double>(0.0, (double s, double v) => s + v).toStringAsFixed(2)} / 12.5');

    bool quizzesRangeOk = true;
    for (var i = 0; i < quizzes.length; i++) {
      final v = quizzes[i];
      if (v < 0 || v > 2.5) {
        quizzesRangeOk = false;
        steps.add('Quiz ${i + 1} must be between 0 and 2.5. (entered: $v)');
      }
    }
    if (quizzesRangeOk) steps.add('Quizzes total: ${quizzes.fold<double>(0.0, (double s, double v) => s + v).toStringAsFixed(2)} / 12.5');

    // If any basic validation fails, show SnackBar and stop
    final hasErrors = steps.any((s) => s.contains('must be') || s.contains('required') || credits <= 0);
    if (hasErrors) {
      // show a dialog listing errors
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Validation issues'),
          content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: steps.map((s) => Text('• $s')).toList())),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      return;
    }

    final course = Course(
      name: name,
      credits: credits,
      finalMarks: finalMarks,
      midMarks: midMarks,
      assignments: assignments,
      quizzes: quizzes,
    );

    // Build final step messages
    final total = course.totalMarks;
    final passFail = course.isFail ? 'Fail' : 'Pass';
    final subjectPoint = course.point;

    final List<Widget> summary = [
      Text('Total marks: ${total.toStringAsFixed(2)} / 100'),
      const SizedBox(height: 6),
      Text('Result: $passFail'),
      const SizedBox(height: 6),
      Text('Subject CGPA (point): ${subjectPoint.toStringAsFixed(2)}'),
    ];

    // Show step-by-step dialog (local alerts)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Course summary'),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Steps:'),
            const SizedBox(height: 8),
            ...steps.map((s) => Text('• $s')),
            const SizedBox(height: 12),
            const Divider(),
            ...summary,
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // add to provider and close
              Provider.of<CourseProvider>(context, listen: false).addCourse(course);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Course "${course.name}" added — ${passFail} — point ${subjectPoint.toStringAsFixed(2)}')),
              );
              // reset
              _nameCtrl.clear();
              _creditsCtrl.clear();
              _finalCtrl.clear();
              _midCtrl.clear();
              for (var c in _assignmentCtrls) c.clear();
              for (var c in _quizCtrls) c.clear();
              setState(() {});
            },
            child: const Text('Confirm & Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _smallNumberField(TextEditingController ctl, String label, String hint) {
    return TextField(
      controller: ctl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 800;
    final fieldWidth = isWide ? 360.0 : double.infinity;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isWide ? 20 : 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(alignment: Alignment.centerLeft, child: Text('Add Course', style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(height: 12),
      
            // Course name + Credits in one row
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: fieldWidth),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Course name'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: isWide ? 140 : 110,
                    child: TextField(
                      controller: _creditsCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Credits'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Final + Mid in one row
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: fieldWidth),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _finalCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Final (out of 50)', hintText: 'e.g. 42'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: isWide ? 160 : 120,
                    child: TextField(
                      controller: _midCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Mid (out of 25)', hintText: 'e.g. 18'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            // Assignments
            Align(alignment: Alignment.centerLeft, child: Text('Assignments (each 0 - 2.5; total 12.5)', style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (i) {
                return SizedBox(
                  width: isWide ? 160 : (MediaQuery.of(context).size.width / 2 - 24),
                  child: _smallNumberField(_assignmentCtrls[i], 'Assignment ${i + 1}', '0 - 2.5'),
                );
              }),
            ),
            const SizedBox(height: 12),
            // Quizzes
            Align(alignment: Alignment.centerLeft, child: Text('Quizzes (each 0 - 2.5; total 12.5)', style: Theme.of(context).textTheme.bodySmall)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (i) {
                return SizedBox(
                  width: isWide ? 160 : (MediaQuery.of(context).size.width / 2 - 24),
                  child: _smallNumberField(_quizCtrls[i], 'Quiz ${i + 1}', '0 - 2.5'),
                );
              }),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('Add Course', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
