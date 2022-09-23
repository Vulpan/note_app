import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/screen/briefcase_screen.dart';
import 'package:note_app/utils/providers/briefcase_note_provider.dart';
import 'package:note_app/utils/providers/item_selected_provider.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:note_app/utils/utils.dart';
import 'package:provider/provider.dart';

class BriefcaseGridView extends StatefulWidget {
  const BriefcaseGridView(
      {super.key,
      required this.briefcase,
      required this.briefcaseCallback,
      this.isAddingNewNotes = false});

  final Briefcase briefcase;
  final ValueChanged<Map<String, dynamic>> briefcaseCallback;
  final bool isAddingNewNotes;

  @override
  State<BriefcaseGridView> createState() => _BriefcaseGridViewState();
}

class _BriefcaseGridViewState extends State<BriefcaseGridView> {
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
  Widget build(BuildContext context) {
    ItemSelectedProvider isp = Provider.of<ItemSelectedProvider>(context);
    BriefcaseNoteProvider briefcaseNoteProvider =
        Provider.of<BriefcaseNoteProvider>(context);
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        InkWell(
          onTap: () {
            if (widget.isAddingNewNotes) {
              widget.briefcaseCallback(mapToTransfer());
            } else if (isp.isSelectionMode) {
              setState(() {
                isSelected = !isSelected;
                widget.briefcaseCallback(mapToTransfer());
              });
            } else {
              briefcaseNoteProvider.currentBriefcase = widget.briefcase.id;
              Navigator.push(
                context,
                Utils().circularPageRoute(
                  BriefcaseScreen(briefcase: widget.briefcase),
                ),
              );
            }
          },
          onLongPress: () {
            if (!isp.isSelectionMode) {
              setState(() {
                isSelected = !isSelected;
                widget.briefcaseCallback(mapToTransfer());
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
                border: Border.all(
                    color: widget.briefcase.secondColor.withOpacity(0.6)),
                color: isSelected
                    ? widget.briefcase.color.withOpacity(0.5)
                    : widget.briefcase.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.briefcase.secondColor == Colors.white
                        ? Colors.black
                        : widget.briefcase.secondColor.withOpacity(0.6),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_sharp,
                    color: widget.briefcase.iconColor,
                    size: 64,
                  ),
                  AutoSizeText(
                    widget.briefcase.title,
                    maxLines: 2,
                    style: TextStyles.titleTextStyle
                        .copyWith(color: widget.briefcase.textColor),
                    textScaleFactor: 1.5,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.briefcase.notes.length.toString(),
                    style: TextStyles.contentTextStyle
                        .copyWith(color: widget.briefcase.textColor),
                  )
                ],
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInCirc,
          child: Icon(
            Icons.check_circle,
            color: widget.briefcase.secondColor,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> mapToTransfer() {
    Map<String, dynamic> map = {
      "object": widget.briefcase,
    };
    return map;
  }

  void itemSelectedListener() {
    if (itemSelectedProvider.isSelected) {
      isSelected = false;
    }
  }
}
