import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poem_challenger/data/poem_data.dart';
import 'package:poem_challenger/pages/menu/home_menu.dart';
import 'package:poem_challenger/pages/tabs/words_tab.dart';
import 'package:poem_challenger/pages/tabs/writing_tab.dart';
import 'package:poem_challenger/util/word_item.dart';

void main() async {

  await Hive.initFlutter();

  Hive.registerAdapter(PoemDataAdapter());
  Hive.registerAdapter(WordItemAdapter());

  await Hive.openBox<PoemData>('poems');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const int whiteColor = 0xFFF5F5F5;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeMenu(),
      title: "Poem Challenger",

      theme:
      ThemeData(
        appBarTheme: AppBarThemeData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF101010),
          titleTextStyle:
            TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(whiteColor),
            ),
        ),

        scaffoldBackgroundColor: Color(0xFF0A0A0A),

        brightness: Brightness.dark,

        textTheme: TextTheme(
          bodyLarge:
            TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.normal,
              color: Color(whiteColor),
            ),
          bodyMedium:
            TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.normal,
              color: Color(whiteColor),
            ),
          bodySmall:
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(whiteColor),
            ),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF101010),
          elevation: 3,
          contentTextStyle: TextStyle(fontSize: 20, color: Color(whiteColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
            side: BorderSide(
              color: Color(whiteColor),
              style: BorderStyle.solid,
              width: 1.0,
            ),
          ),
          behavior: SnackBarBehavior.fixed,
        )

      ),

      routes: {
        '/homemenu': (context) => HomeMenu(),
        '/wordstab': (context) => WordsTab(),
        '/writingtab': (context) => WritingTab(),
      },
    );
  }
}
