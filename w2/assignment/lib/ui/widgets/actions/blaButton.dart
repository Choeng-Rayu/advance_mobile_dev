import 'package:blabla/ui/theme/theme.dart';
import 'package:flutter/material.dart';

/// for test
// void main (){
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: Container(
//           color: const Color.fromARGB(255, 180, 142, 142),
//           padding: const EdgeInsets.all(100),
//           child: Center(
//             child: BlaButton(title: 'mae ah nang', color: Colors.cyanAccent, icon: Icon(Icons.chat_bubble_outline), onTap: () {}),
//           ),
//         )
//       )
//     )
//   );
// }

class BlaButton extends StatelessWidget {
  final String title;
  final Color color;
  final Icon icon;
  final VoidCallback onTap;

  const BlaButton({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, 
      style: ElevatedButton.styleFrom(
        backgroundColor: BlaColors.primary,
      ),
      child: ListTile(
        leading: icon, 
        title: Text(title),
      )
    );
  }
}