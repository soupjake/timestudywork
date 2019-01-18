import 'package:timestudyapp/models/donor.dart';

class Study {
  String name;
  String date;
  String type;
  String team;
  String location;
  List<Donor> donors;

  Study(
      {this.name, this.date, this.type, this.team, this.location, this.donors});

  factory Study.fromJson(Map<String, dynamic> json) {
    var donorsList = json['donors'] as List;

    return Study(
        name: json['name'],
        date: json['date'],
        type: json['type'],
        team: json['team'],
        location: json['location'],
        donors: donorsList.map((i) => Donor.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'type': type,
        'team': team,
        'location': location,
        'donors': donors
      };
}
