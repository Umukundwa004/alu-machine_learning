import 'package:flutter/material.dart';
import 'models/models.dart';
import 'package:intl/intl.dart';

class DataProvider with ChangeNotifier {
  List<Assignment> assignments = [];
  List<AcademicSession> sessions = [];

  DataProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();

    // Sample assignments
    assignments = [
      Assignment(
        id: '1',
        title: 'Mobile App Development Project',
        course: 'Introduction to Flutter Programming',
        dueDate: now.add(const Duration(days: 3)),
        priority: 'High',
        isCompleted: false,
      ),
      Assignment(
        id: '2',
        title: 'Assignment 2',
        course: 'Web Development',
        dueDate: now.add(const Duration(days: 5)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: '3',
        title: 'Group Project',
        course: 'Mobile App (Flutter)',
        dueDate: now.add(const Duration(days: 20)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: '4',
        title: 'Quiz 1',
        course: 'Introduction to Linux',
        dueDate: now.add(const Duration(days: 7)),
        priority: 'Low',
        isCompleted: true,
      ),
    ];

    // Sample sessions
    sessions = [
      AcademicSession(
        id: '1',
        title: 'Introduction to Linux',
        date: now,
        startTime: '09:00',
        endTime: '10:30',
        location: 'Room 101',
        sessionType: 'Class',
        isPresent: true,
      ),
      AcademicSession(
        id: '2',
        title: 'Flutter Programming',
        date: now,
        startTime: '11:00',
        endTime: '12:30',
        location: 'Lab A',
        sessionType: 'Class',
        isPresent: true,
      ),
      AcademicSession(
        id: '3',
        title: 'Web Development',
        date: now.add(const Duration(days: 1)),
        startTime: '14:00',
        endTime: '15:30',
        location: 'Room 205',
        sessionType: 'Class',
        isPresent: false,
      ),
      AcademicSession(
        id: '4',
        title: 'Mastery Session - Flutter',
        date: now.add(const Duration(days: 2)),
        startTime: '15:00',
        endTime: '16:30',
        location: 'Library',
        sessionType: 'Mastery Session',
        isPresent: false,
      ),
    ];
  }

  // Assignment methods
  void addAssignment(Assignment assignment) {
    assignments.add(assignment);
    notifyListeners();
  }

  void updateAssignment(String id, Assignment updatedAssignment) {
    final index = assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      assignments[index] = updatedAssignment;
      notifyListeners();
    }
  }

  void deleteAssignment(String id) {
    assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleAssignmentStatus(String id) {
    final assignment = assignments.firstWhere((a) => a.id == id);
    assignment.isCompleted = !assignment.isCompleted;
    notifyListeners();
  }

  List<Assignment> getUpcomingAssignments(int days) {
    final now = DateTime.now();
    final cutoffDate = now.add(Duration(days: days));
    final upcoming = assignments
        .where((a) => a.dueDate.isAfter(now) && a.dueDate.isBefore(cutoffDate))
        .toList();
    upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return upcoming;
  }

  // Session methods
  void addSession(AcademicSession session) {
    sessions.add(session);
    notifyListeners();
  }

  void updateSession(String id, AcademicSession updatedSession) {
    final index = sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      sessions[index] = updatedSession;
      notifyListeners();
    }
  }

  void deleteSession(String id) {
    sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void toggleAttendance(String id) {
    final session = sessions.firstWhere((s) => s.id == id);
    session.isPresent = !session.isPresent;
    notifyListeners();
  }

  List<AcademicSession> getTodaySessions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return sessions
        .where(
          (s) =>
              DateTime(
                s.date.year,
                s.date.month,
                s.date.day,
              ).compareTo(today) ==
              0,
        )
        .toList();
  }

  List<AcademicSession> getWeekSessions() {
    final now = DateTime.now();
    final endOfWeek = now.add(const Duration(days: 7));
    return sessions
        .where((s) => s.date.isAfter(now) && s.date.isBefore(endOfWeek))
        .toList();
  }

  // Attendance calculation
  double getAttendancePercentage() {
    if (sessions.isEmpty) return 0.0;
    final presentCount = sessions.where((s) => s.isPresent).length;
    return (presentCount / sessions.length) * 100;
  }

  int getPendingAssignmentsCount() {
    return assignments.where((a) => !a.isCompleted).length;
  }

  // Calculate current academic week
  String getCurrentAcademicWeek() {
    final now = DateTime.now();
    // Assuming academic year starts in September
    final academicYearStart = DateTime(
      now.month >= 9 ? now.year : now.year - 1,
      9,
      1,
    );
    final weekNumber = ((now.difference(academicYearStart).inDays) ~/ 7) + 1;
    return 'Week $weekNumber';
  }

  // Get formatted date
  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  }

  // Get assignments due in next 7 days (excluding completed ones)
  List<Assignment> getUpcomingDueAssignments() {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));
    return assignments
        .where(
          (a) =>
              !a.isCompleted &&
              a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(sevenDaysLater),
        )
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }
}
