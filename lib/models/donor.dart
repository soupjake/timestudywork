import 'package:timestudyapp/models/task.dart';

class Donor {
  String name;
  String date;
  String type;
  String team;
  String location;
  int elapsedTime;
  List<Task> tasks;

  Donor(
      {this.name,
      this.date,
      this.type,
      this.team,
      this.location,
      this.elapsedTime,
      this.tasks});

  factory Donor.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;

    return Donor(
        name: json['name'],
        date: json['date'],
        type: json['type'],
        team: json['team'],
        location: json['location'],
        elapsedTime: json['elapsedTime'],
        tasks: tasksList.map((i) => Task.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'type': type,
        'team': team,
        'location': location,
        'elapsedTime': elapsedTime,
        'tasks': tasks
      };
}
