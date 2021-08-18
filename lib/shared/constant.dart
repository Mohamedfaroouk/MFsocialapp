import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mf_app/models/messagemodel.dart';
import 'package:mf_app/modules/Login/login.dart';

var uid;
Widget thewidget = loginscreen();
bool cashdark = false;
String userprofile = "";
String usercover = "";
String username = "";
String? token;
String? backup;
GlobalKey<NavigatorState> contextkey = GlobalKey<NavigatorState>();
List<messagemodel> testmodell = [];
