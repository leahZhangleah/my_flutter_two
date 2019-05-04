import 'dart:convert';
import 'package:meta/meta.dart';

class Staff {
  Staff(
      {@required this.name,
        @required this.id,
        @required this.phone});

  final String name;
  final String phone;
  final String id;

  static List<Staff> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['list']
        .cast<Map<String, dynamic>>()
        .map((obj) => Staff.fromMap(obj))
        .toList()
        .cast<Staff>();
  }

  static Staff fromMap(Map map) {
    return new Staff(
        name: map['name'],
        phone: map['phone'],
        id:map['id']);
  }
}
