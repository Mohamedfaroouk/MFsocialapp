import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/layout/home_layout.dart';
import 'package:mf_app/layout/layoutcubit/cubit_layout.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedcubit.dart';
import 'package:mf_app/modules/Login/logincubit/loginstats.dart';
import 'package:mf_app/modules/profile/profilecubit/profilecubit.dart';
import 'package:mf_app/shared/cash/Cash.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';

class logincubit extends Cubit<loginStats> {
  logincubit() : super(intloginstate());
  static logincubit get(context) => BlocProvider.of(context);
  var email = TextEditingController();
  var password = TextEditingController();
  void login(email, password, context) {
    emit(loginloading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Cach.putcash("uid", value.user?.uid);
      uid = value.user?.uid;
      feedcubit.get(context).iliked = [];
      feedcubit.get(context).posts = [];
      feedcubit.get(context).likes = [];
      FirebaseMessaging.instance.subscribeToTopic(uid);
      profilecubit.get(context).getuserdata(value.user?.uid);
      emit(loginsuccess());
      showtost(text: "Login Success", color: Colors.green);
      navandfinish(context, home());
    }).catchError((value) {
      showtost(text: value.toString(), color: Colors.red);
      emit(loginerror());
    });
  }
}
