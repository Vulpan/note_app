import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/database/repository/briefcase_repository.dart';
import 'package:note_app/database/repository/note_repository.dart';
import 'package:note_app/screen/new_briefcase_screen.dart';
import 'package:note_app/screen/note_detalis_screen.dart';
import 'package:note_app/utils/providers/item_selected_provider.dart';
import 'package:note_app/utils/text_styles.dart';
import 'package:note_app/utils/utils.dart';
import 'package:note_app/widgets/dobule_value_listenable_builder.dart';
import 'package:note_app/widgets/search_bar.dart';
import 'package:note_app/widgets/views/briefcase_grid_view.dart';
import 'package:note_app/widgets/views/note_grid_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> selectedList = [];
  late ItemSelectedProvider isp;
  bool isBreifcaseSelected = false;
  int selectedBriefcases = 0;

  late List<dynamic> elementList;

  @override
  void initState() {
    super.initState();
    elementList = combineList();
  }

  @override
  Widget build(BuildContext context) {
    isp = Provider.of<ItemSelectedProvider>(context);

    return Scaffold(
      appBar: getAppBar(context, isp),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: [
            SearchBar(onPressed: searchBarCallback),
            Expanded(
              child: DoubleValueListenableBuilder(
                firstValue: BriefcaseRepository.getBoxListenable(),
                secondValue: NoteRepository.getBoxListenable(),
                builder: (context, first, second, child) {
                  List list;
                  List newList = combineList();

                  if (listEquals(elementList, newList)) {
                    list = elementList;
                  } else {
                    list = newList;
                    elementList = newList;
                  }

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
                      if (list[index] is Note) {
                        return NoteGridView(
                          note: list[index],
                          isSelectedCallback: isItemSelected,
                        );
                      } else {
                        return BriefcaseGridView(
                          briefcase: list[index],
                          briefcaseCallback: isItemSelected,
                        );
                      }
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            Utils().circularPageRoute(
              NoteDetalisScreen(
                note: Note.empty(),
                isNew: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  int _colForStaggeredView(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  List<dynamic> combineList() {
    List<dynamic> briefcases = BriefcaseRepository.getAll();
    List<dynamic> notes = NoteRepository.getAll();

    if (briefcases.isEmpty) return notes;
    if (notes.isEmpty) return [];

    List<dynamic> notesInUse = [];
    List<dynamic> finalList = [];

    for (int i = 0; i < briefcases.length; i++) {
      notesInUse.addAll(briefcases[i].notes);
    }

    List<dynamic> restNotes = notes;

    for (int i = 0; i < notesInUse.length; i++) {
      for (int j = 0; j < notes.length; j++) {
        if (notesInUse[i] == notes[j]) {
          restNotes.remove(notesInUse[i]);
          continue;
        }
      }
    }

    finalList.addAll(briefcases);
    finalList.addAll(restNotes);

    return finalList;
  }

  AppBar getAppBar(BuildContext context, ItemSelectedProvider isp) {
    return AppBar(
      title: getAppBarTitle(context),
      actions: [
        selectedList.isNotEmpty
            ? IconButton(
                onPressed: () => clearSelectedItems(),
                icon: const Icon(Icons.deselect_sharp),
              )
            : Container(),
        selectedList.isNotEmpty
            ? IconButton(
                onPressed: () => deleteSelectedItems(context, isp),
                icon: const Icon(Icons.delete),
              )
            : Container(),
        selectedList.isNotEmpty && !isBreifcaseSelected
            ? showPopupMenu(context)
            : Container(),
      ],
    );
  }

  Text getAppBarTitle(BuildContext context) {
    if (selectedList.isEmpty) {
      return Text(AppLocalizations.of(context).appName);
    } else {
      return Text(
          "${selectedList.length} ${AppLocalizations.of(context).selectedItems} ");
    }
  }

  void isItemSelected(Map<String, dynamic> map) {
    setState(() {
      Object obj = map["object"];
      if (obj is Note) {
        if (selectedList.contains(obj)) {
          selectedList.remove(obj);
        } else {
          selectedList.add(obj);
        }
      } else if (obj is Briefcase) {
        if (selectedList.contains(obj)) {
          selectedList.remove(obj);
          selectedBriefcases--;
        } else {
          selectedList.add(obj);
          selectedBriefcases++;
        }

        if (selectedBriefcases > 0) {
          isBreifcaseSelected = true;
        } else {
          isBreifcaseSelected = false;
        }
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
      selectedBriefcases = 0;
      isBreifcaseSelected = false;
      selectedList.clear();
      isp.isSelected = true;
      isp.isSelectionMode = false;
      isp.isSelected = false;
    });
  }

  void deleteSelectedItems(BuildContext context, ItemSelectedProvider isp) {
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
              onPressed: () {
                isp.isSelected = true;
                isp.isSelectionMode = false;
                isp.isSelected = false;
                for (int i = 0; i < selectedList.length; i++) {
                  if (selectedList[i] is Note) {
                    NoteRepository.delete(selectedList[i].id);
                  } else if (selectedList[i] is Briefcase) {
                    for (int j = 0; j < selectedList[i].notes.length; j++) {
                      NoteRepository.delete(selectedList[i].notes[j].id);
                    }
                    BriefcaseRepository.delete(selectedList[i].id);
                  }
                }

                clearSelectedItems();

                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).yes,
                  style: TextStyles.contentTextStyle),
            )
          ],
        );
      },
    );
  }

  PopupMenuButton showPopupMenu(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.folder),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).addToFolder)
            ],
          ),
        ),
      ],
      onSelected: ((value) {
        if (value == 1) {
          showNewFolderBottomSheet(context);
        }
      }),
    );
  }

  void showNewFolderBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //New Folder Icons
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    Utils().circularPageRoute(
                      NewBriefcaseScreen(
                        briefcase: Briefcase.empty(
                          title: AppLocalizations.of(context).exampleText,
                        ),
                        selectedList: selectedList,
                        clearSelectedListCallback: clearSelectedItems,
                      ),
                    ),
                  );
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
                          Icons.create_new_folder,
                          color: Colors.yellow,
                          size: 64,
                        ),
                        Text(
                          AppLocalizations.of(context).createNewFolder,
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
                  itemCount: BriefcaseRepository.getAll().length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    List list = BriefcaseRepository.getAll();
                    return BriefcaseGridView(
                      briefcase: list[index],
                      briefcaseCallback: addNotesToBriefcaseCallback,
                      isAddingNewNotes: true,
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  void addNotesToBriefcaseCallback(Map<String, dynamic> map) {
    Briefcase briefcase = map["object"];
    for (int i = 0; i < selectedList.length; i++) {
      briefcase.notes.add(selectedList[i]);
      briefcase.lastEditionDate = DateTime.now();
    }
    BriefcaseRepository.update(briefcase);

    clearSelectedItems();

    Navigator.pop(context);
  }

  void searchBarCallback(String value) {
    List<dynamic> clearList = combineList();
    if (value.isEmpty) {
      setState(() {
        elementList = combineList();
      });
    } else {
      List<dynamic> searchList = [];

      for (var element in clearList) {
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
}
