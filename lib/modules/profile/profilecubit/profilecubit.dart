import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mf_app/models/postmodel.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/profile/profilecubit/profilestats.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';

class profilecubit extends Cubit<profileStats> {
  profilecubit() : super(intprofilestate());
  static profilecubit get(context) => BlocProvider.of(context);
  usermodel? mymodel;
  bool editmode = false;
  bool uploadpic = false;
  bool uploadcover = false;
  void getuserdata(uid) {
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      mymodel = usermodel.fromjson(value.data());
      username = value.data()?["name"];
      userprofile = value.data()?["profilepic"];
      usercover = value.data()?["cover"];

      emit(getdatastate());
    });
  }

  void entereditmode() {
    editmode = !editmode;
    emit(editmodstate());
  }

  void editprofile({
    name,
    bio,
  }) {
    emit(loading());
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      "name": name,
      "bio": bio,
    }).then((value) {
      editmode = false;

      emit(editdatastate());
    }).then((value) {
      getuserdata(uid);
      showtost(text: "Profile Edited succesflly", color: Colors.green);
    }).catchError((onError) {
      showtost(text: onError.toString(), color: Colors.red);
    });
  }

  File? editpic;
  File? editcover;
  final picker = ImagePicker();
  void getimage() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      editpic = File(pickedfile.path);
      uploadpic = true;
    }

    emit(getimagestate());
  }

  void getcoverimage() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      editcover = File(pickedfile.path);
      uploadcover = true;
    }

    emit(getimagestate());
  }

  void uploadprofileppic() {
    emit(loading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/$uid/${Uri.file(editpic!.path).pathSegments.last}")
        .putFile(editpic as File)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userprofile = value;
        FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"profilepic": value}).then((value) {
          getuserdata(uid);
          editmode = false;
          emit(editdatastate());
          showtost(
              text: "Profile Picture uploaded succesfly", color: Colors.green);
          editpic = null;
        }).catchError((onError) {
          showtost(text: onError.toString(), color: Colors.red);
        });
        uploadpic = false;
      });
    });
  }

  void uploadcoverppic() {
    emit(loading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/$uid/${Uri.file(editcover!.path).pathSegments.last}")
        .putFile(editcover as File)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        usercover = value;
        FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"cover": value}).then((value) {
          getuserdata(uid);
          editmode = false;
          showtost(
              text: "Cover Picture uploaded succesfly", color: Colors.green);
          editcover = null;
          emit(editdatastate());
        }).catchError((onError) {
          showtost(text: onError.toString(), color: Colors.red);
        });
        uploadcover = false;
      });
    });
  }

  usermodel? model;
  void getotheruserdata(uid) {
    model?.clear();
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      model = usermodel.fromjson(value.data());

      emit(getdatastate());
    });
  }

  List likes = [];
  List postid = [];
  List<bool> iliked = [];
  List<postmodel> posts = [];
  void getpostsprofile(id) {
    likes = [];
    postid = [];
    iliked = [];
    posts = [];
    FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection("likes").get().then((value) {
          likes.add(value.docs.length - 1);
          iliked.add(false);
          postid.add(element.id);
          bool mylike = false;
          value.docs.where((element) => element.id == uid).forEach((element) {
            mylike = element.data()["like"];
          });
          posts.add(postmodel.fromjason(
              element.data(), mylike, element.id, value.docs.length - 1));

          // value.docs.forEach((element) {
          //   if (element.id == uid) {
          //     iliked.add(element.data()["like"]);
          //   }
          // });

          posts.sort((a, b) {
            return b.date!.compareTo(a.date!);
          });

          emit(readypostsprofile());
        });

        emit(readypostsprofile());
      });
    }).then((value) {
      emit(readypostsprofile());
    }).then((value) {
      emit(readypostsprofile());
    });
  }

  void changeLikeState(postid, index) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postid)
        .collection("likes")
        .doc(uid)
        .set({"like": !iliked[index]}).then((value) {
      iliked[index] = !iliked[index];
      iliked[index]
          ? likes[index] = likes[index] + 1
          : FirebaseFirestore.instance
              .collection("posts")
              .doc(postid)
              .collection("likes")
              .doc(uid)
              .delete()
              .then((value) {
              likes[index] = likes[index] - 1;
              emit(likenumberprofile());
            });
    }).then((value) => emit(likenumberprofile()));
    emit(likestateprofile());
  }
}
