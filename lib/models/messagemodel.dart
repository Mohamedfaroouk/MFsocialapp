import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'messagemodel.g.dart';

@HiveType(typeId: 1)
class messagemodel {
  @HiveField(0)
  String? uid;
  @HiveField(1)
  String? text;
  @HiveField(2)
  String? date = DateTime.now().toString();
  @HiveField(3)
  bool? issend = true;
  @HiveField(4)
  bool? isseen = true;

  messagemodel({
    required this.uid,
    required this.text,
    this.date,
    this.isseen,
    this.issend,
  });
  messagemodel.fromjson(Map<String, dynamic>? jason) {
    uid = jason?["uid"];
    date = jason?["datetime"];
    text = jason?["text"];
    issend = jason?["issend"];
    isseen = jason?["isseen"];
  }
  Map<String, dynamic> modelmap() {
    return {
      "uid": uid,
      "datetime": date,
      "text": text,
    };
  }
}
