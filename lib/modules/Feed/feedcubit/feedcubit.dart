import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mf_app/models/local.dart';
import 'package:mf_app/models/messagemodel.dart';
import 'package:mf_app/models/postmodel.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedstats.dart';
import 'package:mf_app/modules/profile/profilecubit/profilestats.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class feedcubit extends Cubit<feedStats> {
  feedcubit() : super(intstate());
  static feedcubit get(context) => BlocProvider.of(context);

  bool like = false;
  List<bool> iliked = [];
  void changeLikeState(postid, index, postmodel model) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postid)
        .collection("likes")
        .doc(uid)
        .set({"like": true}).then((value) {
      model.iliked = !model.iliked!;
      model.iliked!
          ? model.likes = model.likes! + 1
          : FirebaseFirestore.instance
              .collection("posts")
              .doc(postid)
              .collection("likes")
              .doc(uid)
              .delete()
              .then((value) {
              model.likes = model.likes! - 1;
              emit(likenumber());
            });
    }).then((value) => emit(likenumber()));
    emit(likestate());
  }

  File? postpic;
  final picker = ImagePicker();

  void getpostimage() async {
    var thepicked = await picker.getImage(source: ImageSource.gallery);
    if (thepicked != null) {
      postpic = File(thepicked.path);
      emit(postimageready());
    }
  }

  void removepic() {
    postpic = null;
    emit(postimageremoved());
  }

  DateTime time = DateTime.now();

  void addpost(
    String text,
  ) {
    emit(loadingaddpost());
    if (postpic == null) {
      FirebaseFirestore.instance.collection("posts").add({
        "uid": uid,
        "name": username,
        "userprofile": userprofile,
        "haspic": false,
        "text": text,
        "date": DateTime.now()
      }).then((value) {
        value.collection("likes").add({"like": false});
        showtost(text: "Post upload successfly", color: Colors.green);
        emit(sucessaddpost());
      }).catchError((onError) {
        showtost(text: onError.toString(), color: Colors.green);
      });
    } // .child("users/$uid/${Uri.file(editpic!.path).pathSegments.last}")
    else {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Posts/${Uri.file(postpic!.path).pathSegments.last}")
          .putFile(postpic as File)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          return FirebaseFirestore.instance
              .collection("posts")
              .add({
                "uid": uid,
                "name": username,
                "userprofile": userprofile,
                "haspic": true,
                "pic": value,
                "text": text,
                "date": DateTime.now()
              })
              .then((value) => value.collection("likes").add({"like": false}))
              .catchError((onError) {});
        }).catchError((onError) {});
      }).then((value) {
        showtost(text: "Post upload successfly", color: Colors.green);
        emit(sucessaddpost());
      }).catchError((onError) {
        showtost(text: onError.toString(), color: Colors.green);
      });
    }
  }

  List likes = [];
  List postid = [];

  List<postmodel> posts = [];

  void getposts() {
    FirebaseFirestore.instance.collection("posts").get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection("likes").get().then((value) {
          if (posts.every((item) => item.postid != element.id)) {
            likes.add(value.docs.length - 1);
            iliked.add(false);
            bool mylike = false;
            value.docs.where((element) => element.id == uid).forEach((element) {
              mylike = element.data()["like"];
            });
            posts.add(postmodel.fromjason(
                element.data(), mylike, element.id, value.docs.length - 1));

            postid.add(element.id);

            // value.docs.forEach((element) {
            //   if (element.id == uid) {
            //     iliked.add(element.data()["like"]);
            //   }
            // });

            posts.sort((a, b) {
              return b.date!.compareTo(a.date!);
            });
          }

          emit(readyposts());
        });

        emit(readyposts());
      });
    }).then((value) {
      emit(readyposts());
    });
  }

  void onrefresh(RefreshController controller) async {
    await Future.delayed(Duration(microseconds: 1000));
    getposts();
    controller.refreshCompleted();

    emit(finshload());
  }

  void onloading(RefreshController controller) async {
    await Future.delayed(Duration(microseconds: 1000));
    getposts();
    controller.loadComplete();
    emit(finshload());
  }

  void onrefreshusers(RefreshController controller) async {
    await Future.delayed(Duration(microseconds: 1000));
    getallusers();
    controller.refreshCompleted();

    emit(finshload());
  }

  void onloadingusers(RefreshController controller) async {
    await Future.delayed(Duration(microseconds: 1000));
    getallusers();
    controller.loadComplete();
    emit(finshload());
  }

  Map<String, String> profilepics = {};
  List<usermodel> usermodel2 = [];
  Map<String, Widget> unseen = {};

  void getallusers() {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        if (usermodel2.every((item) => item.email != element.data()["email"])) {
          usermodel2.add(usermodel.fromjson(element.data()));
          profilepics[element.id] = element.data()["profilepic"];
        }
      });
    }).then((value) {
      print(profilepics[uid]);
      emit(getallusersstate());
    }).catchError((onError) {});
  }

  void sendmessage({text, resiverid, TextEditingController? control}) {
    emit(sendloadingsucess());
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("chats")
        .doc(resiverid)
        .collection("messages")
        .add({
      "datetime": DateTime.now(),
      "text": text,
      "uid": uid,
      "issend": false,
      "isseen": false
    }).then((value) {
      value.update({
        "issend": true,
      });
      emit(sendsucess());
    }).catchError(onError);
    FirebaseFirestore.instance
        .collection("users")
        .doc(resiverid)
        .collection("chats")
        .doc(uid)
        .collection("messages")
        .add({
      "datetime": DateTime.now(),
      "text": text,
      "uid": uid,
      "issend": false,
      "isseen": false
    }).then((value) {
      value.update({
        "issend": true,
      });
      emit(sendsucess());
    }).catchError(onError);
  }

  Map<String, List<messagemodel>> chatlist = {};
  List<messagemodel> mymessegemodel = [];
  List<bool> seenicons = [];
  // void getmessage({resiverid}) {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .collection("chats")
  //       .doc(resiverid)
  //       .collection("messages")
  //       .orderBy("datetime", descending: true)
  //       .snapshots()
  //       .listen((event) {
  //     mymessegemodel = [];

  //     event.docs.forEach((element) {
  //       mymessegemodel.add(messagemodel.fromjson(element.data()));

  //       chatlist[resiverid] = mymessegemodel;
  //       emit(getmessegesucess());
  //     });
  //     readmessge(resiverid);
  //     emit(getmessegesucess());
  //   });
  // }

  // Widget? theicon;
  // void readmessge(resiverid) {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(resiverid)
  //       .collection("chats")
  //       .doc(uid)
  //       .collection("messages")
  //       .where("uid", isEqualTo: resiverid)
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       element.reference.update({"isseen": true});
  //     });
  //   }).then((value) => emit(readsucess()));
  // }
  Box<localmodel> localmesseges = Hive.box<localmodel>("nnn");
  var scroll = ScrollController();

  void addthetestmessege(messagemodel model, id) async {
    testmodell.add(model);
    localmesseges.put(id, localmodel(thelist: testmodell));
    print(id);
    // firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child("backup/$uid/nnn.hive")
    //     .putFile(File("/data/user/0/com.example.mf_app/app_flutter/nnn.hive"));
    scroll.animateTo(scroll.position.minScrollExtent - 200,
        duration: Duration(microseconds: 300), curve: Curves.easeInOut);
    emit(getmessegesucess());
  }

  void getdatalocal(String uiid) async {
    List<messagemodel> data = localmesseges.get(uiid) as List<messagemodel>;
    testmodell = data;

    emit(getmessegesucess());
  }
}
