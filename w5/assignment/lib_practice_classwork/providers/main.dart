// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FinanceService {
//   final int totalIncomes;
//   final int totalExpenses;

//   FinanceService({required this.totalIncomes, required this.totalExpenses});
// }

// void main() {
//   // runApp(MaterialApp(home: FinanceApp()));
//   runApp(MaterialApp(
//     home: Provider(
//       create: (context) => FinanceService(totalIncomes: 1000, totalExpenses: 2000),
//       child: FinanceApp(),
//     ),
//   ));
// }

// class FinanceApp extends StatelessWidget {
//   const FinanceApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     FinanceService financeService = context.read<FinanceService>();
//     return Scaffold(body: Text("expenses = ${financeService.totalExpenses} and Income ${financeService.totalIncomes}"));
//   }
// }

















