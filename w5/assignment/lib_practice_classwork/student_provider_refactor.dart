import 'package:flutter/material.dart';

// SERVICES

class StudentsService {
  String getStudents() => "Students loaded";
}

class CourseService {
  String getCourses() => "Courses loaded";
}

class GradesService {
  String getGrades() => "Grades loaded";
}

// GLOBAL SERVICES INSTANCES

StudentsService globalStudentsService = StudentsService();
CourseService globalCourseService = CourseService();
GradesService globalGradesService = GradesService();

// MAIN ---------------------------------------

void main() {
  runApp(MaterialApp(home: App()));
}

// UI
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School App - Global Services")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          StudentsScreen(),
          CoursesScreen(),
          GradesScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Direct global access
    final data = globalStudentsService.getStudents();

    return Text("StudentsScreen → $data");
  }
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = globalCourseService.getCourses();

    return Text("CoursesScreen → $data");
  }
}

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Direct global access
    final grades = globalGradesService.getGrades();
    final students = globalStudentsService.getStudents();
    final courses = globalCourseService.getCourses();

    return Text("GradesScreen → $grades for $students for $courses");
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("Seeting");
  }
}
