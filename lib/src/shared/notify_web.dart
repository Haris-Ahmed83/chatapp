import 'dart:js' as js;

void notifyFlutterReady() {
  js.context.callMethod('flutterReady');
}
