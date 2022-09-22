import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/database/model/briefcase_model.dart';
import 'package:note_app/database/model/note_model.dart';
import 'package:note_app/database/repository/briefcase_repository.dart';
import 'package:note_app/database/repository/note_repository.dart';
import 'package:note_app/screen/home_screen.dart';
import 'package:note_app/utils/providers/briefcase_note_provider.dart';
import 'package:note_app/utils/providers/item_selected_provider.dart';
import 'package:note_app/utils/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(BriefcaseAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox(StringConstants.noteModelBoxName);
  await Hive.openBox(StringConstants.briefcaseModelBoxName);
  NoteRepository.init(StringConstants.noteModelBoxName);
  BriefcaseRepository.init(StringConstants.briefcaseModelBoxName);

  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ItemSelectedProvider()),
        ChangeNotifierProvider(create: (context) => BriefcaseNoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Note App',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
