import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:mf_app/layout/layoutcubit/layoutstats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/modules/Friends.dart';
import 'package:mf_app/modules/Login/login.dart';
import 'package:mf_app/modules/profile/profile.dart';
import 'package:mf_app/modules/addpost.dart';
import 'package:mf_app/modules/Feed/home.dart';
import 'package:mf_app/modules/profile/profilecubit/profilecubit.dart';
import 'package:mf_app/modules/search.dart';
import 'package:mf_app/modules/setting.dart';
import 'package:mf_app/shared/cash/Cash.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';

class layoutcubit extends Cubit<layoutStats> {
  layoutcubit() : super(intstate());
  static layoutcubit get(context) => BlocProvider.of(context);
  int myindex = 0;
  List<Widget> screens = [
    homescreen(),
    notifications(),
    addpostscreen(),
    friendsscreen(),
    settingscreen(),
  ];
  List<String> titles = [
    "Feeds",
    "Notifications",
    "AddPost",
    "Friends",
    "Setting"
  ];

  void changescreen(index) {
    myindex = index;
    emit(changemyscreen());
  }

  bool dark = false;
  void darkmode() {
    dark = !dark;
    Cach.putcash("dark", dark);
    emit(changemode());
  }

  void darkmodeonstatr(fromcacsh) {
    dark = fromcacsh;

    emit(changemode());
  }

  void logout(context) {
    Cach.removecash(key: "uid");
    imageCache!.clear();
    imageCache!.clearLiveImages();
    FirebaseMessaging.instance.unsubscribeFromTopic(uid);
    navandfinish(context, loginscreen());
    emit(logoutstat());
  }

  void gettheuserdata(context) {
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      userprofile = value.data()?["profilepic"];
      emit(readystat());
    });
  }
}
