import 'package:timestudyapp/models/attribute.dart';

class Stage {
  String name;
  int time;
  List<Attribute> attributes;

  Stage({this.name, this.time, this.attributes});

  factory Stage.fromJson(Map<String, dynamic> json) {
    var attributesList = json['attributes'] as List;

    return Stage(
        name: json['name'],
        time: json['time'],
        attributes: attributesList.map((i) => Attribute.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'time': time, 'attributes': attributes};
}
