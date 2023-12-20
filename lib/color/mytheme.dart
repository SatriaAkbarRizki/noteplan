import 'package:flutter/material.dart';

class MyTheme {
  get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xffF8F0E5),
        primaryColor: const Color(0xffF8F0E5),
        textTheme: const TextTheme(
          titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'wixmadefor',
              height: 2,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Colors.black, fontSize: 25),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'wixmadefor',
            height: 2,
          ),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
          displaySmall: TextStyle(
              fontFamily: 'wixmadefor',
              fontSize: 16,
              color: Color.fromARGB(255, 166, 161, 179)),
        ),
        cardColor: Colors.black,
        colorScheme: const ColorScheme.light(
          background: Color(0xffE19898),
        ),
        primaryColorDark: const Color(0xffC7EBB3),
        canvasColor: const Color.fromARGB(255, 233, 204, 204),
        indicatorColor: const Color(0xffE19898),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xffE19898),
            refreshBackgroundColor: Color(0xffF8F0E5)),
        popupMenuTheme:
            PopupMenuThemeData(color: const Color(0xffF8F0E5), elevation: 0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xffF8F0E5),
        ),
      );

  get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0XFF1C1C1F),
        textTheme: const TextTheme(
          titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'wixmadefor',
              height: 2,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: Color.fromARGB(255, 166, 161, 179), fontSize: 25),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'wixmadefor',
            height: 2,
          ),
          bodyMedium: TextStyle(
              color: Color.fromARGB(255, 166, 161, 179), fontSize: 16),
          displaySmall: TextStyle(
              fontFamily: 'wixmadefor',
              fontSize: 16,
              color: Color.fromARGB(255, 234, 234, 235)),
        ),
        colorScheme: const ColorScheme.dark(background: Color(0xffC7EBB3)),
        primaryColorDark: const Color(0xffE19898),
        buttonTheme: const ButtonThemeData(),
        cardColor: const Color.fromARGB(255, 177, 174, 184),
        canvasColor: Colors.grey,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xffC7EBB3), refreshBackgroundColor: Colors.black),
        popupMenuTheme:
            PopupMenuThemeData(color: Color(0xffC7EBB3), elevation: 0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0XFF1C1C1F)),
      );

  get signTheme => ThemeData(
      textTheme: const TextTheme(
          titleSmall: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'wixmadefor',
              height: 2,
              fontWeight: FontWeight.w600),
          bodySmall: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'wixmadefor',
              height: 2,
              fontWeight: FontWeight.w600)));
}
