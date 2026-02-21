import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

// StudentsService globalStudentsService = StudentsService();
// CourseService globalCourseService = CourseService();
// GradesService globalGradesService = GradesService();

// MAIN ---------------------------------------

void main() {
  runApp(MaterialApp(home: App()));
  // runApp(MaterialApp(home:
  // )));
}

// UI
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School App - Global Services")),
      body: MultiProvider(
        providers: [
          Provider<StudentsService>(
            create: (context) => StudentsService(),
            child: StudentsScreen(),
          ),
          Provider<GradesService>(
            create: (context) => GradesService(),
            child: GradesScreen(),
          ),
          Provider(
            create: (context) => CourseService(),
            child: CoursesScreen(),
          ),
        ],
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [StudentsScreen(), CoursesScreen(), GradesScreen(), SettingsScreen()],
      ),

      ),
    );
  }
}

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});
  // final int data;

  @override
  Widget build(BuildContext context) {
    // Direct global access
    StudentsService data = context.read<StudentsService>();
    return Text("StudentsScreen → $data");
  }
}

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});
  // final int data;
  @override
  Widget build(BuildContext context) {
    // final data = globalCourseService.getCourses();
    CourseService data = context.read<CourseService>();
    return Text("CoursesScreen → $data");
  }
}

class GradesScreen extends StatelessWidget {
  const GradesScreen({
    super.key,
    // required this.grades,
    // required this.students,
    // required this.courses,
  });
  // final int grades;
  // final int students;
  // final int courses;
  @override
  Widget build(BuildContext context) {
    // Direct global access
    // final grades = globalGradesService.getGrades();
    // final students = globalStudentsService.getStudents();
    // final courses = globalCourseService.getCourses();
    GradesService grades = context.read<GradesService>();
    StudentsService students = context.read<StudentsService>();
    CourseService courses = context.read<CourseService>();

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
