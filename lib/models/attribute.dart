class Attribute {
  String name;
  bool value;

  Attribute({this.name, this.value});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(name: json['name'], value: json['value']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
