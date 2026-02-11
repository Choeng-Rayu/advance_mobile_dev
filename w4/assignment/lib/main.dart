// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         colorScheme: .fromSeed(
// //           seedColor: const Color.fromARGB(255, 102, 0, 255),
// //         ),
// //       ),
// //       home: const MyHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});

// //   final String title;

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   int _counter = 0;

// //   void _incrementCounter() {
// //     setState(() {
// //       _counter++;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         child: Column(
// //           // mainAxisAlignment: .center,
// //           // children: [
// //           //   const Text('You have pushed the button this many times:'),
// //           //   Text(
// //           //     '$_counter',
// //           //     style: Theme.of(context).textTheme.headlineMedium,
// //           //   ),
// //           //   Text('This is the blue'),
// //           // ],
// //           children: [
// //             Con
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _incrementCounter,
// //         tooltip: 'Increment',
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(body: Home()),
//     ),
//   );
// }

// enum CardType { red, blue }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int redTaps = 0;
//   int blueTaps = 0;

//   void _incrementRed() => setState(() => redTaps++);
//   void _incrementBlue() => setState(() => blueTaps++);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 50),
//       child: Column(
//         children: [
//           StatisticsSummary(redTaps: redTaps, blueTaps: blueTaps),
//           ColorTap(type: CardType.red, onTap: _incrementRed, tapCount: redTaps),
//           ColorTap(
//             type: CardType.blue,
//             onTap: _incrementBlue,
//             tapCount: blueTaps,
//           ),
//           // ColorTap(
//           //   type: CardType.blue,
//           //   onTap: _incrementBlue,
//           //   tapCount: blueTaps,
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class StatisticsSummary extends StatelessWidget {
//   final int redTaps;
//   final int blueTaps;

//   const StatisticsSummary({
//     super.key,
//     required this.redTaps,
//     required this.blueTaps,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(10),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 255, 255, 255),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Statistics Summary',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: const Color.fromARGB(255, 214, 206, 206),
//             ),
//           ),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 'Red Taps: $redTaps',
//                 style: TextStyle(fontSize: 16, color: Colors.red[300]),
//               ),
//               Text(
//                 'Blue Taps: $blueTaps',
//                 style: TextStyle(fontSize: 16, color: Colors.blue[300]),
//               ),
//               // Text(
//               //   'Total: ${redTaps + blueTaps}',
//               //   style: TextStyle(fontSize: 16, color: Colors.white),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ColorTap extends StatelessWidget {
//   final CardType type;
//   final VoidCallback onTap;
//   final int tapCount;

//   const ColorTap({
//     super.key,
//     required this.type,
//     required this.onTap,
//     required this.tapCount,
//   });

//   Color get backgroundColor => type == CardType.red ? Colors.red : Colors.blue;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         width: double.infinity,
//         height: 100,
//         child: Center(
//           child: Text(
//             'Taps: $tapCount',
//             style: TextStyle(fontSize: 24, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

enum CardType { red, blue }

///
/// Handle the number of taps per color
///
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int redTapCount = 0;
  int blueTapCount = 0;

  void _incrementRedTapCount() {
    setState(() {
      redTapCount++;
    });
  }

  void _incrementBlueTapCount() {
    setState(() {
      blueTapCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatisticsScreen(blueTaps: blueTapCount, redTaps: redTapCount),
        ColorTap(
          type: CardType.red,
          onTap: _incrementRedTapCount,
          tapCount: redTapCount,
        ),
        ColorTap(
          type: CardType.blue,
          onTap: _incrementBlueTapCount,
          tapCount: blueTapCount,
        ),
      ],
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;
  final int tapCount;
  final VoidCallback onTap;

  const ColorTap({
    super.key,
    required this.type,
    required this.tapCount,
    required this.onTap,
  });

  Color get backgroundColor => type == CardType.red ? Colors.red : Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  final int redTaps;
  final int blueTaps;

  const StatisticsScreen({
    super.key,
    required this.redTaps,
    required this.blueTaps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Red Taps: $redTaps', style: TextStyle(fontSize: 24)),
        Text('Blue Taps: $blueTaps', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}
