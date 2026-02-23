import 'package:flutter/material.dart';
import 'package:poem_challenger/util/button_tile.dart';

class DeleteUI extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final String poemName;

  const DeleteUI({
      super.key,
      required this.onDelete,
      required this.onCancel,
      required this.poemName,
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
              Column(
                spacing: 1.0,
                children: [
                  Text("Supprimer ce poème ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Text(poemName,
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.parent,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Boutons : OUI / NON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonTile(
                    text: "OUI",
                    boxColor: Colors.red.toARGB32(),
                    textColor: Color(0xFFF5F5F5),
                    onPressed: onDelete
                  ),
                    ButtonTile(
                      text: "NON",
                      boxColor: 0x50F5F5F5,
                      textColor: Color(0x80000000),
                      onPressed: onCancel
                    ),
                  ],
                )
              ],
            ),
      ),
    );
  }
}