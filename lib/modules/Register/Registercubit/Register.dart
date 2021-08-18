import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/Login/login.dart';
import 'package:mf_app/modules/Register/Registercubit/Registerstats.dart';
import 'package:mf_app/shared/componants.dart';

class registercubit extends Cubit<registerStats> {
  registercubit() : super(intregstate());
  static registercubit get(context) => BlocProvider.of(context);

  void reg(email, password, context, name) {
    emit(regloading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("yes");
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .set(usermodel(
            uid: value.user!.uid,
            email: email,
            name: name,
          ).modelmap());
      emit(regstat());
      showtost(text: "Register Success", color: Colors.green);
      navto(context, loginscreen());
    }).catchError((onError) {
      showtost(text: onError.toString(), color: Colors.red);
      print(onError.toString());
      emit(regerror());
    });
  }
}
