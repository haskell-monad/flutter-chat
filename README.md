# flutterchat


## 國際化
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/i10n/ lib/i10n/i10n.dart

flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/i10n --no-use-deferred-loading lib/i10n/i10n.dart lib/i10n/intl_*.arb
