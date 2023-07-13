import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

const String black = '\u001b[30m';
const String blue = '\u001b[34m';
const String red = '\u001b[31m';
const String brightRed = '\u001b[31;1m';
const String green = '\u001b[32m';
const String yellow = '\u001b[33m';
const String reset = '\u001b[0m';

void initRootLogger() {
  // only enable logging for debug mode
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.OFF;
  }
  hierarchicalLoggingEnabled = true;

  // specify the levels for lower level loggers, if desired
  // Logger('SiteInfoService').level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    if (!kDebugMode) {
      return;
    }

    var start = reset;
    const end = reset;

    switch (record.level.name) {
      case 'INFO':
        start = blue;
        break;
      case 'WARNING':
        start = yellow;
        break;
      case 'SEVERE':
        start = brightRed;
        break;
      case 'SHOUT':
        start = red;
        break;
    }

    print('$start${record.loggerName} : ${record.level} : ${record.time} : ${record.message}$end');
  });
}