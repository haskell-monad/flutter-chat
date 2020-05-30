import 'package:flutter/material.dart';
import 'package:flutterchat/ui/views/chat/chat_list.dart';
import 'package:flutterchat/ui/views/matrix.dart';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'core/i10n/i10n.dart';
import 'core/services/localstorage_service.dart';
import 'locator.dart';
import 'ui/shared/theme.dart';

import 'ui/views/index.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(App());
}

class App extends StatelessWidget {

//  var storageService = locator<LocalStorageService>();


  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "iron-im-chat",
      child: MaterialApp (
          title: 'iron-chat',
          theme: darkTheme,
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('zh'), // Chinese
          ],
          locale: kIsWeb
              ? Locale(html.window.navigator.language.split('-').first)
              : null,
          home: Index()
      ),
    );
  }
}
