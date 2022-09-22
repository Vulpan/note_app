import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/repository/briefcase_repository.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:note_app/utils/utils.dart';
import 'package:note_app/widgets/color_slider.dart';
import 'package:note_app/widgets/views/briefcase_grid_view.dart';

class NewBriefcaseScreen extends StatefulWidget {
  const NewBriefcaseScreen(
      {super.key,
      required this.briefcase,
      required this.selectedList,
      required this.clearSelectedListCallback});

  final Briefcase briefcase;
  final List<dynamic> selectedList;
  final VoidCallback clearSelectedListCallback;

  @override
  State<NewBriefcaseScreen> createState() => _NewBriefcaseScreenState();
}

class _NewBriefcaseScreenState extends State<NewBriefcaseScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).createNewFolder,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                AppLocalizations.of(context).preview,
                style: TextStyles.contentTextStyle,
              ),
              BriefcaseGridView(
                briefcase: widget.briefcase,
                briefcaseCallback: (map) {},
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).title,
                style: TextStyles.contentTextStyle,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context).enterName,
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 158, 158, 158),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              namedColorSlider(
                context,
                AppLocalizations.of(context).mainColor,
                widget.briefcase.color,
                Utils().firstColors,
                1,
              ),
              namedColorSlider(
                context,
                AppLocalizations.of(context).secondColor,
                widget.briefcase.secondColor,
                Utils().secondColors,
                2,
              ),
              namedColorSlider(
                context,
                AppLocalizations.of(context).iconColor,
                widget.briefcase.iconColor,
                Utils().secondColors,
                3,
              ),
              namedColorSlider(
                context,
                AppLocalizations.of(context).textColor,
                widget.briefcase.textColor,
                Utils().textColors,
                4,
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    widget.briefcase.title = textController.text;
                    widget.briefcase.id =
                        Utils().generateId(BriefcaseRepository.getAll());
                    widget.briefcase.creationDate = DateTime.now();
                    widget.briefcase.lastEditionDate = DateTime.now();

                    for (int i = 0; i < widget.selectedList.length; i++) {
                      widget.briefcase.notes.add(widget.selectedList[i]);
                    }

                    BriefcaseRepository.add(widget.briefcase);
                    widget.clearSelectedListCallback();

                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    final snackBar = SnackBar(
                        content: Text(
                      AppLocalizations.of(context).thatAreaIsRequired,
                    ));
                    ScaffoldMessenger(child: snackBar);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueAccent,
                  ),
                  child: Text(
                    AppLocalizations.of(context).create,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget namedColorSlider(BuildContext context, String text, Color color,
      List<Color> colors, int sliderNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyles.contentTextStyle,
        ),
        SizedBox(
          height: 60,
          child: ColorSlider(
            color: color,
            callback: colorSliderCallback,
            listOfColors: colors,
            sliderNumber: sliderNumber,
          ),
        ),
      ],
    );
  }

  void colorSliderCallback(int whichSlider, Color color) {
    setState(() {
      switch (whichSlider) {
        case 1:
          widget.briefcase.color = color;
          break;
        case 2:
          widget.briefcase.secondColor = color;
          break;
        case 3:
          widget.briefcase.iconColor = color;
          break;
        case 4:
          widget.briefcase.textColor = color;
          break;
        default:
      }
    });
  }
}
