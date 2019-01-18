import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/models/stage.dart';

class Task {
  String name;
  List<Stage> stages;
  List<Donor> donors;

  Task({this.name, this.stages, this.donors});

  factory Task.fromJson(Map<String, dynamic> json) {
    var stagesList = json['stages'] as List;
    var donorsList = json['donors'] as List;

    return Task(
        name: json['name'],
        stages: stagesList.map((i) => Stage.fromJson(i)).toList(),
        donors: donorsList.map((i) => Donor.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'stages': stages, 'donors': donors};
}
