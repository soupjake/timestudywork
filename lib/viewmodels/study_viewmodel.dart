import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:timestudyapp/models/stage.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timestudyapp/models/task.dart';

class StudyViewModel {
  static List<Study> studies = new List<Study>();
  static List<Task> tasks = new List<Task>();

  static Future load() async {
    try {
      await getTasks();
      File file = await getFile();
      String studiesJson = await file.readAsString();
      if (studiesJson != null) {
        List studiesParsed = json.decode(studiesJson);
        studies = studiesParsed.map((i) => Study.fromJson(i)).toList();
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/studies.json');
  }

  static Future saveFile() async {
    File file = await getFile();
    file.writeAsString(json.encode(studies));
  }

  static Future getTasks() async {
    List jsonParsed =
        json.decode(await rootBundle.loadString('assets/tasks.json'));
    tasks = jsonParsed.map((i) => new Task.fromJson(i)).toList();
  }

  static bool checkName(String name) {
    bool match = false;
    for (int i = 0; i < studies.length; i++) {
      if (studies[i].name == name) {
        match = true;
        break;
      }
    }
    return match;
  }

  static List<Stage> copyStages(Task task) {
    List stagesParsed = json.decode(json.encode(task.stages));
    return stagesParsed.map((i) => new Stage.fromJson(i)).toList();
  }

  static String milliToElapsedString(int milliseconds) {
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return minutesStr + ':' + secondsStr + ':' + hundredsStr;
  }

  static Future exportData(String name) async {
    List<Task> tasks = new List<Task>();
    for (int i = 0; i < studies.length; i++) {
      tasks.addAll(studies[i].tasks);
    }
    String url = 'mailto:?subject=' + name + ' Data&body=' + json.encode(tasks);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
