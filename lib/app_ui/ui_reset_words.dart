import 'package:flutter/material.dart';
import 'package:poem_challenger/util/button_tile.dart';

class ResetWordsUI extends StatelessWidget {
  final String message;
  final VoidCallback onReset;
  final VoidCallback onCancel;

  const ResetWordsUI({
      super.key,
      required this.message,
      required this.onReset,
      required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text("Cette action est irréversible.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            
            // Boutons : OUI / NON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTile(
                  text: "OUI",
                  boxColor: Colors.red.toARGB32(),
                  textColor: Color(0xFFF5F5F5),
                  onPressed: onReset
                ),
                ButtonTile(
                  text: "NON",
                  boxColor: 0x50F5F5F5,
                  textColor: Color(0x80000000),
                  onPressed: onCancel
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}