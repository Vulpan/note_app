import 'package:flutter/material.dart';
import 'package:note_app/utils/utils.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.onPressed});

  final ValueChanged<String> onPressed;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(Icons.search),
          suffixIcon: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
            opacity: textController.text.isNotEmpty ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: () {
                Utils().closeKeyboard(context);
                textController.text = "";
                widget.onPressed("");
              },
              child: const Icon(Icons.clear),
            ),
          ),
        ),
        onChanged: (value) => widget.onPressed(value),
      ),
    );
  }
}
