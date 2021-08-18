import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mf_app/models/messagemodel.dart';
part 'local.g.dart';

@HiveType(typeId: 2)
class localmodel {
  @HiveField(0)
  List<messagemodel>? thelist;

  localmodel({
    required this.thelist,
  });
}
