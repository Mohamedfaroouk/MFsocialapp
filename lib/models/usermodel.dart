import 'package:flutter/material.dart';

class usermodel {
  String? uid;
  String? email;
  String? name;
  String? bio;
  String? profilepic;
  String? cover;
  usermodel({
    this.uid,
    this.email,
    this.name,
    this.bio = "",
    this.profilepic =
        "https://firebasestorage.googleapis.com/v0/b/mfsocialapp-5d2ef.appspot.com/o/profile.jpg?alt=media&token=6cbae31e-ff49-4580-8f00-01b1cf00ae1e",
    this.cover =
        "https://firebasestorage.googleapis.com/v0/b/mfsocialapp-5d2ef.appspot.com/o/cover.jpg?alt=media&token=29ba107d-525e-4d03-a1ae-b2f41ad20cc8",
  });
  usermodel.fromjson(Map<String, dynamic>? jason) {
    uid = jason?["uid"];
    name = jason?["name"];
    email = jason?["email"];
    bio = jason?["bio"];
    profilepic = jason?["profilepic"];
    cover = jason?["cover"];
  }
  Map<String, dynamic> modelmap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "bio": bio,
      "profilepic": profilepic,
      "cover": cover
    };
  }

  void clear() {
    uid = "";
    email = "";
    name = "";
    bio = "";
    profilepic = "";
    cover = "";
  }
}
