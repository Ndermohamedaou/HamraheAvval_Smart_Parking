import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// This Function only use to web build of Flutter.
// For more info check this:
// https://docs.flutter.dev/development/ui/navigation/url-strategies
configApp() {
  setUrlStrategy(PathUrlStrategy());
}
