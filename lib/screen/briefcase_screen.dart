import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/database/repository/briefcase_repository.dart';
import 'package:note_app/database/repository/note_repository.dart';
import 'package:note_app/screen/note_detalis_screen.dart';
import 'package:note_app/utils/providers/briefcase_note_provider.dart';
import 'package:note_app/utils/providers/item_selected_provider.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:note_app/utils/utils.dart';
import 'package:note_app/widgets/color_slider.dart';
import 'package:note_app/widgets/search_bar.dart';
import 'package:note_app/widgets/views/briefcase_grid_view.dart';
import 'package:note_app/widgets/views/note_grid_view.dart';
import 'package:provider/provider.dart';

class BriefcaseScreen extends StatefulWidget {
  const BriefcaseScreen({super.key, required this.briefcase});
  final Briefcase briefcase;

  @override
  State<BriefcaseScreen> createState() => _BriefcaseScreenState();
}

class _BriefcaseScreenState extends State<BriefcaseScreen> {
  List<dynamic> selectedList = [];
  late ItemSelectedProvider isp;
  late BriefcaseNoteProvider briefcaseNoteProvider;

  late List<dynamic> elementList;

  TextEditingController enterNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    elementList = widget.briefcase.notes;
  }

  @override
  Widget build(BuildContext context) {
    isp = Provider.of<ItemSelectedProvider>(context);
    briefcaseNoteProvider = Provider.of<BriefcaseNoteProvider>(context);

    return Scaffold(
      appBar: getAppBar(context, isp),
      backgroundColor: widget.briefcase.color,
      body: Column(
        children: [
          SearchBar(onPressed: searchBarCallback),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: NoteRepository.getBoxListenable(),
              builder: (context, value, child) {
                List list = elementList;
                list.sort(
                  (a, b) {
                    return b.lastEditionDate.compareTo(a.lastEditionDate);
                  },
                );
                return StaggeredGrid.count(
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: _colForStaggeredView(context),
                  children: List.generate(list.length, (index) {
                    return NoteGridView(
                      note: list[index],
                      isSelectedCallback: isItemSelected,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: getEndDrawer(context),
      floatingActionButton: selectedList.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                briefcaseNoteProvider.currentBriefcase = widget.briefcase.id;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteDetalisScreen(
                      note: Note.empty(),
                      isNew: true,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }

  int _colForStaggeredView(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  AppBar getAppBar(BuildContext context, ItemSelectedProvider isp) {
    return AppBar(
      title: getAppBarTitle(context),
      backgroundColor: widget.briefcase.secondColor,
      leading: IconButton(
        onPressed: () {
          briefcaseNoteProvider.currentBriefcase = -1;
          briefcaseNameChange();
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        selectedList.isNotEmpty
            ? IconButton(
                onPressed: () => clearSelectedItems(),
                icon: const Icon(Icons.deselect_sharp),
              )
            : Container(),
        IconButton(
          onPressed: () {
            if (selectedList.isEmpty) {
              showDeleteDialog(context, () => deleteBriefcase(context));
            } else {
              showDeleteDialog(
                  context, () => deleteSelectedItems(context, isp));
            }
          },
          icon: const Icon(Icons.delete),
        ),
        selectedList.isNotEmpty
            ? IconButton(
                onPressed: () => showMoveToFolderBottomSheet(context),
                icon: const Icon(Icons.move_to_inbox_sharp),
              )
            : Container(),
        selectedList.isEmpty
            ? Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.more_vert),
                );
              })
            : Container(),
      ],
    );
  }

  Text getAppBarTitle(BuildContext context) {
    if (selectedList.isEmpty) {
      return Text(widget.briefcase.title);
    } else {
      return Text(
          "${selectedList.length} ${AppLocalizations.of(context).selectedItems} ");
    }
  }

  Drawer getEndDrawer(BuildContext context) {
    return Drawer(
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
              AppLocalizations.of(context).title,
              style: TextStyles.contentTextStyle,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: TextField(
                controller: enterNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context).enterName,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                  suffixIcon: TextButton(
                    onPressed: () => briefcaseNameChange(),
                    child: const Text("ok"),
                  ),
                ),
                onEditingComplete: () => briefcaseNameChange(),
                onSubmitted: (value) => briefcaseNameChange(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).mainColor,
              style: TextStyles.contentTextStyle,
            ),
            SizedBox(
              height: 60,
              child: ColorSlider(
                color: widget.briefcase.color,
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
                color: widget.briefcase.secondColor,
                callback: colorSliderCallback,
                listOfColors: Utils().secondColors,
                sliderNumber: 2,
              ),
            ),
            Text(
              AppLocalizations.of(context).iconColor,
              style: TextStyles.contentTextStyle,
            ),
            SizedBox(
              height: 60,
              child: ColorSlider(
                color: widget.briefcase.iconColor,
                callback: colorSliderCallback,
                listOfColors: Utils().secondColors,
                sliderNumber: 3,
              ),
            ),
            Text(
              AppLocalizations.of(context).textColor,
              style: TextStyles.contentTextStyle,
            ),
            SizedBox(
              height: 60,
              child: ColorSlider(
                color: widget.briefcase.textColor,
                callback: colorSliderCallback,
                listOfColors: Utils().textColors,
                sliderNumber: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void isItemSelected(Map<String, dynamic> map) {
    setState(() {
      Object obj = map["object"];
      if (selectedList.contains(obj)) {
        selectedList.remove(obj);
      } else {
        selectedList.add(obj);
      }

      if (selectedList.isEmpty) {
        isp.isSelectionMode = false;
      } else {
        isp.isSelectionMode = true;
      }
    });
  }

  void clearSelectedItems() {
    setState(() {
      selectedList.clear();
      isp.isSelected = true;
      isp.isSelectionMode = false;
      isp.isSelected = false;
    });
  }

  void showDeleteDialog(BuildContext context, Function onYesPressed) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).areYouSure,
            style: TextStyles.titleTextStyle,
          ),
          content: Text(
            AppLocalizations.of(context).deleteMessage,
            style: TextStyles.contentTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).no,
                  style: TextStyles.contentTextStyle),
            ),
            TextButton(
              onPressed: () => deleteSelectedItems(context, isp),
              child: Text(AppLocalizations.of(context).yes,
                  style: TextStyles.contentTextStyle),
            )
          ],
        );
      },
    );
  }

  void deleteSelectedItems(BuildContext context, ItemSelectedProvider isp) {
    int lengthOfNotes = widget.briefcase.notes.length;
    isp.isSelected = false;
    List deleteItems = [];
    for (int i = 0; i < selectedList.length; i++) {
      deleteItems.add(selectedList[i]);
      widget.briefcase.notes.remove(selectedList[i]);
      NoteRepository.delete(selectedList[i].id);
    }

    if (deleteItems.length == lengthOfNotes) {
      Navigator.pop(context);
      Navigator.pop(context);
      BriefcaseRepository.delete(widget.briefcase.id);
      briefcaseNoteProvider.currentBriefcase = -1;
    } else {
      BriefcaseRepository.update(widget.briefcase);
      clearSelectedItems();
      Navigator.pop(context);
    }
  }

  void deleteBriefcase(BuildContext context) {
    briefcaseNoteProvider.currentBriefcase = -1;
    Navigator.pop(context);
    for (int i = 0; i < widget.briefcase.notes.length; i++) {
      NoteRepository.delete(widget.briefcase.notes[i].id);
    }
    BriefcaseRepository.delete(widget.briefcase.id);
    isp.isSelectionMode = false;
  }

  void colorSliderCallback(int whichSlider, Color color) {
    setState(() {
      switch (whichSlider) {
        case 1:
          widget.briefcase.color = color;
          BriefcaseRepository.update(widget.briefcase);
          break;
        case 2:
          widget.briefcase.secondColor = color;
          BriefcaseRepository.update(widget.briefcase);
          break;
        case 3:
          widget.briefcase.iconColor = color;
          BriefcaseRepository.update(widget.briefcase);
          break;
        case 4:
          widget.briefcase.textColor = color;
          BriefcaseRepository.update(widget.briefcase);
          break;
        default:
      }
    });
  }

  void showMoveToFolderBottomSheet(BuildContext context) {
    List list = BriefcaseRepository.getAll();
    list.remove(widget.briefcase);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //New Folder Icons
              InkWell(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);

                  for (int i = 0; i < selectedList.length; i++) {
                    widget.briefcase.notes.remove(selectedList[i]);
                  }

                  if (widget.briefcase.notes.isEmpty) {
                    BriefcaseRepository.delete(widget.briefcase.id);
                  } else {
                    BriefcaseRepository.update(widget.briefcase);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.yellowAccent.withOpacity(0.55)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.folder_off_rounded,
                          color: Colors.yellow,
                          size: 64,
                        ),
                        Text(
                          AppLocalizations.of(context).moveToMainFolder,
                          style: TextStyles.titleTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Folder List
              Expanded(
                child: GridView.builder(
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    return BriefcaseGridView(
                      briefcase: list[index],
                      briefcaseCallback: moveNotesToOtherBriefcase,
                      isAddingNewNotes: true,
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  void moveNotesToOtherBriefcase(Map<String, dynamic> map) {
    Briefcase briefcase = map["object"];
    for (int i = 0; i < selectedList.length; i++) {
      widget.briefcase.notes.remove(selectedList[i]);
      briefcase.notes.add(selectedList[i]);
      briefcase.lastEditionDate = DateTime.now();
    }
    if (widget.briefcase.notes.isEmpty) {
      BriefcaseRepository.delete(widget.briefcase.id);
    } else {
      BriefcaseRepository.update(widget.briefcase);
    }

    clearSelectedItems();

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void searchBarCallback(String value) {
    if (value.isEmpty) {
      setState(() {
        elementList = widget.briefcase.notes;
      });
    } else {
      List<dynamic> searchList = [];

      for (var element in elementList) {
        if (element.title.contains(value)) {
          searchList.add(element);
        }
      }

      setState(() {
        elementList.clear();
        elementList.addAll(searchList);
      });
    }
  }

  void briefcaseNameChange() {
    if (enterNameController.text.isNotEmpty) {
      setState(() {
        widget.briefcase.title = enterNameController.text;
        BriefcaseRepository.update(widget.briefcase);
      });
    }
  }
}
