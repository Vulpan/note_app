import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/screen/note_detalis_screen.dart';
import 'package:note_app/utils/providers/item_selected_provider.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:note_app/utils/utils.dart';
import 'package:provider/provider.dart';

class NoteGridView extends StatefulWidget {
  const NoteGridView(
      {super.key, required this.note, required this.isSelectedCallback});

  final Note note;
  final ValueChanged<Map<String, dynamic>> isSelectedCallback;

  @override
  State<NoteGridView> createState() => _NoteGridViewState();
}

class _NoteGridViewState extends State<NoteGridView> {
  bool isSelected = false;
  late ItemSelectedProvider itemSelectedProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      itemSelectedProvider =
          Provider.of<ItemSelectedProvider>(context, listen: false);
      itemSelectedProvider.addListener(itemSelectedListener);
    });
  }

  @override
  void dispose() {
    super.dispose();
    itemSelectedProvider.removeListener(itemSelectedListener);
  }

  @override
  Widget build(BuildContext context) {
    ItemSelectedProvider isp = Provider.of<ItemSelectedProvider>(context);
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        InkWell(
          onTap: () {
            if (isp.isSelectionMode) {
              setState(() {
                isSelected = !isSelected;
                widget.isSelectedCallback(mapToTransfer());
              });
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetalisScreen(note: widget.note),
                ),
              );
            }
          },
          onLongPress: () {
            if (!isp.isSelectionMode) {
              setState(() {
                isSelected = !isSelected;
                widget.isSelectedCallback(mapToTransfer());
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInCirc,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: widget.note.secondColor.withOpacity(0.6)),
                color: isSelected
                    ? widget.note.color.withOpacity(0.5)
                    : widget.note.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.note.secondColor.withOpacity(0.6),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: _constructChild(),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInCirc,
          child: Icon(
            Icons.check_circle,
            color: widget.note.secondColor,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> mapToTransfer() {
    Map<String, dynamic> map = {
      "object": widget.note,
    };
    return map;
  }

  Column _constructChild() {
    List<Widget> children = [];

    if (widget.note.title.isNotEmpty) {
      children.add(AutoSizeText(
        widget.note.title,
        maxLines: widget.note.title.isEmpty ? 1 : 3,
        style: TextStyles.titleTextStyle.copyWith(color: widget.note.textColor),
        textScaleFactor: 1.5,
      ));
    }

    children.add(const SizedBox(height: 2));

    children.add(Text(
      Utils().dateFormat(2).format(widget.note.creationDate),
      style: TextStyles.dateTextStyle,
    ));

    children.add(const SizedBox(height: 2));

    if (widget.note.content.isNotEmpty) {
      children.add(AutoSizeText(
        widget.note.content,
        maxLines: 10,
        style:
            TextStyles.contentTextStyle.copyWith(color: widget.note.textColor),
        textScaleFactor: 1.5,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  void itemSelectedListener() {
    if (itemSelectedProvider.isSelected) {
      isSelected = false;
    }
  }
}
