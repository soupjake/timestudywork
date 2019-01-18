import 'package:timestudyapp/models/task.dart';

class Study {
  String name;
  String date;
  String type;
  String team;
  String location;
  List<Task> tasks;

  Study(
      {this.name, this.date, this.type, this.team, this.location, this.tasks});

  factory Study.fromJson(Map<String, dynamic> json) {
    var tasksList = json['tasks'] as List;

    return Study(
        name: json['name'],
        date: json['date'],
        type: json['type'],
        team: json['team'],
        location: json['location'],
        tasks: tasksList.map((i) => Task.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'type': type,
        'team': team,
        'location': location,
        'tasks': tasks
      };
}
