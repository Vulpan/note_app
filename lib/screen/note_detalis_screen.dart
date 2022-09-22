import 'package:flutter/material.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/database/repository/briefcase_repository.dart';
import 'package:note_app/database/repository/note_repository.dart';
import 'package:note_app/utils/providers/briefcase_note_provider.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app/utils/utils.dart';
import 'package:note_app/widgets/color_slider.dart';
import 'package:provider/provider.dart';

class NoteDetalisScreen extends StatefulWidget {
  const NoteDetalisScreen({
    super.key,
    required this.note,
    this.isNew = false,
  });

  final Note note;
  final bool isNew;

  @override
  State<NoteDetalisScreen> createState() => _NoteDetalisScreenState();
}

class _NoteDetalisScreenState extends State<NoteDetalisScreen> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController contentControler = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  late BriefcaseNoteProvider briefcaseNoteProvider;
  late int briefcaseId;

  @override
  void initState() {
    super.initState();
    titleControler.text = widget.note.title;
    contentControler.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    briefcaseNoteProvider = Provider.of<BriefcaseNoteProvider>(context);
    briefcaseId = briefcaseNoteProvider.currentBriefcase;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Utils().closeKeyboard(context);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => saveButtonClicked(context),
            icon: const Icon(Icons.save),
          ),
          !widget.isNew
              ? IconButton(
                  onPressed: () => deleteButtonClicked(context),
                  icon: const Icon(Icons.delete),
                )
              : Container(),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Utils().closeKeyboard(context);
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.more_vert),
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    AppLocalizations.of(context).customize,
                    style: TextStyles.titleTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).mainColor,
                style: TextStyles.contentTextStyle,
              ),
              SizedBox(
                height: 60,
                child: ColorSlider(
                  color: widget.note.color,
                  callback: colorSliderCallback,
                  listOfColors: Utils().firstColors,
                  sliderNumber: 1,
                ),
              ),
              Text(
                AppLocalizations.of(context).secondColor,
                style: TextStyles.contentTextStyle,
              ),
              SizedBox(
                height: 60,
                child: ColorSlider(
                  color: widget.note.secondColor,
                  callback: colorSliderCallback,
                  listOfColors: Utils().secondColors,
                  sliderNumber: 2,
                ),
              ),
              Text(
                AppLocalizations.of(context).textColor,
                style: TextStyles.contentTextStyle,
              ),
              SizedBox(
                height: 60,
                child: ColorSlider(
                  color: widget.note.textColor,
                  callback: colorSliderCallback,
                  listOfColors: Utils().textColors,
                  sliderNumber: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: widget.note.color),
        child: Column(
          children: [
            TextField(
              controller: titleControler,
              focusNode: titleFocusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context).title,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
              ),
              style: TextStyles.titleTextStyle
                  .copyWith(color: widget.note.textColor),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils().dateFormat(3).format(widget.note.creationDate),
                  style: TextStyles.dateTextStyle,
                ),
                Text(
                  widget.isNew
                      ? ""
                      : Utils()
                          .dateFormat(3)
                          .format(widget.note.lastEditionDate),
                  style: TextStyles.dateTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: contentControler,
                focusNode: contentFocusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).startWriting,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),
                maxLines: null,
                expands: true,
                style: TextStyles.contentTextStyle
                    .copyWith(color: widget.note.textColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  void colorSliderCallback(int whichSlider, Color color) {
    setState(() {
      switch (whichSlider) {
        case 1:
          widget.note.color = color;
          NoteRepository.update(widget.note);
          break;
        case 2:
          widget.note.secondColor = color;
          NoteRepository.update(widget.note);
          break;
        case 3:
          widget.note.textColor = color;
          NoteRepository.update(widget.note);
          break;
        default:
      }
    });
  }

  void saveButtonClicked(BuildContext context) {
    String title = titleControler.text;
    String content = contentControler.text;

    if (widget.isNew) {
      widget.note.id = Utils().generateId(NoteRepository.getAll());
    }
    if (title.isNotEmpty || content.isNotEmpty) {
      widget.note.title = title;
      widget.note.content = content;

      NoteRepository.add(widget.note);

      if (briefcaseId != -1) {
        Briefcase briefcase = BriefcaseRepository.get(briefcaseId);
        briefcase.notes.add(widget.note);
        briefcase.lastEditionDate = DateTime.now();
        BriefcaseRepository.update(briefcase);
      }

      Navigator.pop(context);
    } else {
      final snackbar = SnackBar(
        content: Text(AppLocalizations.of(context).titleOrContentCannotBeEmpty),
      );

      ScaffoldMessenger(child: snackbar);
    }
  }

  void deleteButtonClicked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).areYouSure,
              style: TextStyles.titleTextStyle),
          content: Text(AppLocalizations.of(context).deleteMessage,
              style: TextStyles.contentTextStyle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).no,
                  style: TextStyles.contentTextStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                if (briefcaseId != -1) {
                  Briefcase briefcase = BriefcaseRepository.get(briefcaseId);
                  briefcase.notes.remove(widget.note);
                  if (briefcase.notes.isEmpty) {
                    Navigator.pop(context);
                    BriefcaseRepository.delete(briefcase.id);
                  } else {
                    BriefcaseRepository.update(briefcase);
                  }
                }
                NoteRepository.delete(widget.note.id);
                briefcaseNoteProvider.currentBriefcase = -1;
              },
              child: Text(AppLocalizations.of(context).yes,
                  style: TextStyles.contentTextStyle),
            ),
          ],
        );
      },
    );
  }
}
