import 'package:flutter/material.dart';

ThemeData layoutTheme = ThemeData(
  buttonTheme: ButtonThemeData(
    buttonColor: DNSColor,
  ),
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.white,
      )),
  primaryColor: DNSColor,
  accentColor: Colors.white,
  primaryTextTheme: whiteText,
);

final ButtonStyle dnsButtonStyle = ElevatedButton.styleFrom(
  primary: DNSColor,
);

const MaterialColor DNSColor = const MaterialColor(
  0xFFEE8E19,
  const <int, Color>{
    50: const Color(0x0DEE8E19),
    100: const Color(0x1AEE8E19),
    200: const Color(0x33EE8E19),
    300: const Color(0x4DEE8E19),
    400: const Color(0x66EE8E19),
    500: const Color(0x80EE8E19),
    600: const Color(0x99EE8E19),
    700: const Color(0xB3EE8E19),
    800: const Color(0xCCEE8E19),
    900: const Color(0xE6EE8E19),
  },
);

const TextTheme whiteText = const TextTheme(
  headline6: TextStyle(color: Colors.white),
);