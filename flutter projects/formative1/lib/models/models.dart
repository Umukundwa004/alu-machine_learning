// Data Models for Student Academic Platform

class Assignment {
  String id;
  String title;
  String course;
  DateTime dueDate;
  String priority; // High, Medium, Low
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      course: json['course'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      priority: json['priority'] ?? 'Medium',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}

class AcademicSession {
  String id;
  String title;
  DateTime date;
  String startTime;
  String endTime;
  String location;
  String sessionType; // Class, Mastery Session, Study Group, PSL Meeting
  bool isPresent;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    this.sessionType = 'Class',
    this.isPresent = false,
  });

  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    return AcademicSession(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '10:00',
      location: json['location'] ?? '',
      sessionType: json['sessionType'] ?? 'Class',
      isPresent: json['isPresent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'sessionType': sessionType,
      'isPresent': isPresent,
    };
  }
}
