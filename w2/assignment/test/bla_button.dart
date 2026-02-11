import '../lib/ui/widgets/actions/blaButton.dart';
import 'package:flutter/material.dart';

void main() {
  BlaButton button =  BlaButton(
    title: 'Test Button',
    color: const Color.fromARGB(255, 255, 0, 0),
    icon: Icon(Icons.add),
    onTap: () {
      print('Button tapped!');
    },
  );

  // Simulate a button tap
  button.onTap();
}