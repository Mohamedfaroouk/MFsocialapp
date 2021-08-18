import 'package:cloud_firestore/cloud_firestore.dart';

class postmodel {
  String? uid;
  String? name;
  String? userprofile;
  bool? haspic;
  String? pic;
  String? text;
  String? postid;
  bool? iliked;
  int? likes;
  Timestamp? date;

  postmodel({
    this.uid,
    this.name,
    this.userprofile,
    this.haspic,
    this.pic,
    this.text,
    this.date,
    this.postid,
    this.likes,
    this.iliked = false,
  });

  postmodel.fromjason(Map<String, dynamic> jason, iliked1, postid1, likes1) {
    uid = jason["uid"];
    name = jason["name"];
    userprofile = jason["userprofile"];
    haspic = jason["haspic"];

    pic = jason["pic"];

    text = jason["text"];
    date = jason["date"];
    postid = postid1;
    likes = likes1;
    iliked = iliked1;
  }
}
