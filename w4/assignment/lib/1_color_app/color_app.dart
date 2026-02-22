import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}



enum CardType {
  red(Colors.red),
  blue(Colors.blue);

  final Color color;
  const CardType(this.color);
}


class ColorService extends ChangeNotifier {
  final Map<CardType, int> _tapCounts = {
    for (var type in CardType.values) type: 0,
  };

  Map<CardType, int> get tapCounts => _tapCounts;

  int getCount(CardType type) => _tapCounts[type] ?? 0;

  void increment(CardType type) {
    _tapCounts[type] = getCount(type) + 1;
    notifyListeners(); // 🔥 This triggers ListenableBuilder
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorService = ColorService(); // global instance

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(service: colorService),
    );
  }
}


class Home extends StatefulWidget {
  final ColorService service;

  const Home({super.key, required this.service});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ColorTapsScreen(service: widget.service),
          StatisticsScreen(service: widget.service),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}


class ColorTapsScreen extends StatelessWidget {
  final ColorService service;

  const ColorTapsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Color Taps')),
      body: Column(
        children: CardType.values
            .map((type) => ColorTap(type: type, service: service))
            .toList(),
      ),
    );
  }
}

// Uses ListenableBuilder


class ColorTap extends StatelessWidget {
  final CardType type;
  final ColorService service;

  const ColorTap({super.key, required this.type, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service, // 🔥 HERE IS ListenableBuilder
      builder: (context, _) {
        final tapCount = service.getCount(type);

        return GestureDetector(
          onTap: () => service.increment(type),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: type.color,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                'Taps: $tapCount',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}


// SCREEN STATISTICS
// Uses ListenableBuilder


class StatisticsScreen extends StatelessWidget {
  final ColorService service;

  const StatisticsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListenableBuilder(
        listenable: service, // 🔥 HERE IS ListenableBuilder
        builder: (context, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: service.tapCounts.entries.map((entry) {
                return Text(
                  '${entry.key.name} Taps: ${entry.value}',
                  style: const TextStyle(fontSize: 24),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
