import 'package:flutter/material.dart';

// SERVICES ---------------------------------------

class StudentsService {
  final bool isTest;
  StudentsService({required this.isTest});

  String getStudents() =>
      isTest ? "Students (TEST mode)" : "Students (REAL mode)";
}

class CourseService {
  String getCourses() => "Courses loaded";
}

class GradesService {
  String getGrades() => "Grades loaded";
}

// MAIN ---------------------------------------

void main() {
  //  Services created at root (owned here)
  final studentsService = StudentsService(isTest: false);
  final courseService = CourseService();
  final gradesService = GradesService();

  runApp(
    App(
      studentsService: studentsService,
      courseService: courseService,
      gradesService: gradesService,
    ),
  );
}

// UI ---------------------------------------

class App extends StatelessWidget {
  final StudentsService studentsService;
  final CourseService courseService;
  final GradesService gradesService;

  const App({
    super.key,
    required this.studentsService,
    required this.courseService,
    required this.gradesService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        studentsService: studentsService,
        courseService: courseService,
        gradesService: gradesService,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final StudentsService studentsService;
  final CourseService courseService;
  final GradesService gradesService;

  const HomeScreen({
    super.key,
    required this.studentsService,
    required this.courseService,
    required this.gradesService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School App - Manual DI")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StudentsScreen(studentsService: studentsService),
          const Divider(),
          CoursesScreen(courseService: courseService),
          const Divider(),
          GradesScreen(gradesService: gradesService),
        ],
      ),
    );
  }
}

// SCREENS ---------------------------------------

class StudentsScreen extends StatelessWidget {
  final StudentsService studentsService;

  const StudentsScreen({super.key, required this.studentsService});

  @override
  Widget build(BuildContext context) {
    return Text("StudentsScreen → ${studentsService.getStudents()}");
  }
}

class CoursesScreen extends StatelessWidget {
  final CourseService courseService;

  const CoursesScreen({super.key, required this.courseService});

  @override
  Widget build(BuildContext context) {
    return Text("CoursesScreen → ${courseService.getCourses()}");
  }
}

class GradesScreen extends StatelessWidget {
  final GradesService gradesService;

  const GradesScreen({super.key, required this.gradesService});

  @override
  Widget build(BuildContext context) {
    return Text("GradesScreen → ${gradesService.getGrades()}");
  }
}
