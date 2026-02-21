import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterService {
  final int count;

  CounterService({required this.count});
}

void main() {
  runApp(
    MaterialApp(
      home: Provider(
        create: (context) => CounterService(count: 25),
        child: CountScreen(),
      ),
    ),
  );
}

class CountScreen extends StatelessWidget {
  const CountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CounterService myService = context.read<CounterService>();
    return Center(child: Text(myService.count.toString()));
  }
}
