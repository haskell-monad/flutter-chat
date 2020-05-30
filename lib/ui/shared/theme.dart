import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Themes {
  light,
  dark,
  system,
}

final ThemeData lightTheme = ThemeData(
  primaryColorDark: Colors.white,
  primaryColorLight: Color(0xff121212),
  brightness: Brightness.light,
  primaryColor: Color(0xFF5625BA),
  backgroundColor: Colors.white,
  secondaryHeaderColor: Color(0xFFECECF2),
  scaffoldBackgroundColor: Colors.white,
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColorDark: Color(0xff1B1B1B),
  primaryColorLight: Colors.white,
  primaryColor: Color(0xFF8966CF),
  errorColor: Color(0xFFCF6679),
  backgroundColor: Color(0xff121212),
  scaffoldBackgroundColor: Color(0xff1B1B1B),
  accentColor: Color(0xFFF5B4D2),
  secondaryHeaderColor: Color(0xff202020),
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Color(0xff1D1D1D),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

final ThemeData amoledTheme = ThemeData.dark().copyWith(
  primaryColorDark: Color(0xff121212),
  primaryColorLight: Colors.white,
  primaryColor: Color(0xFF8966CF),
  errorColor: Color(0xFFCF6679),
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  accentColor: Color(0xFFF5B4D2),
  secondaryHeaderColor: Color(0xff1D1D1D),
  snackBarTheme: SnackBarThemeData(
    behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Color(0xff1D1D1D),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
);


class ThemeState extends ChangeNotifier {
  ThemeData _themeData; //主题
  int _colorIndex; //主题

  ThemeState(this._colorIndex, this._themeData);

  void changeThemeData(int colorIndex, ThemeData themeData) {
    _themeData = themeData;
    _colorIndex = colorIndex;
    notifyListeners();
  }

  ThemeData get themeData => _themeData; //获取主题
  int get colorIndex => _colorIndex; //获取数字
}

class ThemeSwitch extends StatelessWidget {
  final Widget child;
  ThemeSwitch({this.child});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ThemeState>(
        create: (context) => ThemeState(1, darkTheme),
        child: child
    );
  }
}
