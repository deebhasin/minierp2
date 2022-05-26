import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LogFile {
  static final LogFile _singleton = LogFile._internal();

  factory LogFile() {
    return _singleton;
  }
  LogFile._internal();

  List<String> _logList = [];
  late File file;

  List<String> get logList {
    return _logList;
  }

  void logEntry(Object log) {
    log = DateFormat("d-MM-yyyy H:m:s").format(DateTime.now()) +
        ":      " +
        log.toString();
    _logList.add(log.toString());
    file.writeAsStringSync('$log\n',mode: FileMode.append);
    if (_logList.length > 50) _logList.removeAt(0);
    print(log);
  }

  Future<void> getFile() async {
    final directory = await getApplicationSupportDirectory();
    final String fileName = join(directory.path, "Org", "Logs", "logfile.txt");
    file = await File(fileName).create(recursive: true);

    //***** Folder created to Store Images *****
    final fileNameForImageFolder = join(directory.path, "Org", "Images", "test.txt");
    File fileForImageFolder = await File(fileNameForImageFolder).create(recursive: true);

  }

  Future<void> init() async{
    await getFile();
  }

}
