import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class CourseList extends StatelessWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context);
    final courses = provider.courses;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 800;

    return Column(
      children: [
        Card(
          child: ListTile(
            title: const Text('CGPA'),
            subtitle: Text('Total Credits: ${provider.totalCredits.toStringAsFixed(2)}'),
            trailing: Text(
              provider.cgpa.toStringAsFixed(2),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: courses.isEmpty
              ? Center(child: Text('No courses added', style: TextStyle(color: Colors.grey[700])))
              : ListView.separated(
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final c = courses[i];
                    final total = c.totalMarks;
                    final point = c.point;
                    final status = c.isFail ? 'Fail' : 'Pass';
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12, vertical: 8),
                      title: Text(c.name),
                      subtitle: Text('Credits: ${c.credits}  •  Marks: ${total.toStringAsFixed(2)}  •  $status'),
                      trailing: Text(point.toStringAsFixed(2)),
                      onLongPress: () => provider.removeAt(i),
                    );
                  },
                ),
        ),
        const SizedBox(height: 6),
        Text('Tip: Long-press a course to remove it.', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
