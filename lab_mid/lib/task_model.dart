class Task {
  int? id;
  String title;
  String description;
  String dueDate;
  int isCompleted;
  int isRepeated;
  double progress;
  String priority; // ✅ new field

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = 0,
    this.isRepeated = 0,
    this.progress = 0.0,
    this.priority = 'Medium', // ✅ default
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'isRepeated': isRepeated,
      'progress': progress,
      'priority': priority, // ✅ added
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      isCompleted: map['isCompleted'],
      isRepeated: map['isRepeated'],
      progress: map['progress'],
      priority: map['priority'] ?? 'Medium',
    );
  }
}
