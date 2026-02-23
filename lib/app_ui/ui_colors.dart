
import 'package:flutter/material.dart';

class ColorsUI extends StatefulWidget {
  final Function(Color) onSelectColor;
  final VoidCallback onCancel;

  const ColorsUI({
      super.key,
      required this.onSelectColor,
      required this.onCancel,
  });

  @override
  State<ColorsUI> createState() => _ColorsUIState();
}

class _ColorsUIState extends State<ColorsUI> {

  List<Color> colors = Colors.accents;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      child: SizedBox(
        height: 260,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => widget.onSelectColor(colors[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.subdirectory_arrow_left_rounded,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: widget.onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}