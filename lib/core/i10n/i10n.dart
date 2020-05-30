
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<L10n> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de', 'hu', 'pl', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<L10n> load(Locale locale) {
    return L10n.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<L10n> old) {
    return false;
  }
}

class L10n {
  L10n(this.localeName);

  static Future<L10n> load(Locale locale) {
    final String name =
    locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return L10n(localeName);
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  final String localeName;

  /* <=============> Translations <=============> */

  String defaultConnectedHomeServer(String homeServer) => Intl.message(
    'By default you will be connected to $homeServer',
    name: 'DefaultConnectedHomeServer',
    args: [homeServer],
  );

  String get connect => Intl.message('Connect');

  String get welcomeText => Intl.message(
      'Welcome to the cutest instant messenger in the matrix network.');

  String get enterYourHomeServer => Intl.message('Enter your homeServer');

  String get changeHomeServer => Intl.message('Change the homeServer');

  String get setProfilePicture => Intl.message("Set a profile picture");

  String get discardPicture => Intl.message("Discard picture");

  String get username => Intl.message("Username");

  String get chooseAUsername => Intl.message("Choose a username");
  String get pleaseChooseAUsername => Intl.message("Please choose a username");

  String get signUp => Intl.message("Sign up");

  String get alreadyHaveAnAccount => Intl.message("Already have an account?");

  String get password => Intl.message("Password");
  String get chooseAStrongPassword => Intl.message("Choose a strong password");
  String get pleaseEnterYourPassword =>
      Intl.message("Please enter your password");

  String get createAccountNow => Intl.message("Create account now");

  String get couldNotSetAvatar => Intl.message("Could not set avatar");

  String get couldNotSetDisplayName =>
      Intl.message("Could not set displayName");

  String get ok => Intl.message('ok');

  String get close => Intl.message("Close");

  String get confirm => Intl.message("Confirm");
  String get areYouSure => Intl.message("Are you sure?");
  String get loadingPleaseWait => Intl.message("Loading... Please wait");

}