import 'package:timestudyapp/models/stage.dart';

class Task {
  String name;
  int measuredTime;
  int waitedTime;
  int elapsedTime;
  String note;
  List<Stage> stages;

  Task(
      {this.name,
      this.measuredTime,
      this.waitedTime,
      this.elapsedTime,
      this.note,
      this.stages});

  factory Task.fromJson(Map<String, dynamic> json) {
    var stagesList = json['stages'] as List;

    return Task(
        name: json['name'],
        measuredTime: json['measuredTime'],
        waitedTime: json['waitedTime'],
        elapsedTime: json['elapsedTime'],
        note: json['note'],
        stages: stagesList.map((i) => Stage.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'measuredTime': measuredTime,
        'waitedTime': waitedTime,
        'elapsedTime': elapsedTime,
        'note': note,
        'stages': stages
      };
}
