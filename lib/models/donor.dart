import 'package:timestudyapp/models/stage.dart';

class Donor {
  String name;
  String date;
  String type;
  String team;
  String location;
  int measuredTime;
  int waitedTime;
  int elapsedTime;
  String note;
  List<Stage> stages;

  Donor(
      {this.name,
      this.date,
      this.type,
      this.team,
      this.location,
      this.measuredTime,
      this.waitedTime,
      this.elapsedTime,
      this.note,
      this.stages});

  factory Donor.fromJson(Map<String, dynamic> json) {
    var stagesList = json['stages'] as List;

    return Donor(
        name: json['name'],
        date: json['date'],
        type: json['type'],
        team: json['team'],
        location: json['location'],
        measuredTime: json['measuredTime'],
        waitedTime: json['waitedTime'],
        elapsedTime: json['elapsedTime'],
        note: json['note'],
        stages: stagesList.map((i) => Stage.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'type': type,
        'team': team,
        'location': location,
        'measuredTime': measuredTime,
        'waitedTime': waitedTime,
        'elapsedTime': elapsedTime,
        'note': note,
        'stages': stages
      };
}
