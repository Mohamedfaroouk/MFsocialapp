import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';

import 'package:mf_app/layout/home_layout.dart';
import 'package:mf_app/layout/layoutcubit/cubit_layout.dart';
import 'package:mf_app/layout/layoutcubit/layoutstats.dart';
import 'package:mf_app/models/local.dart';
import 'package:mf_app/models/messagemodel.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedcubit.dart';
import 'package:mf_app/modules/Friends.dart';
import 'package:mf_app/modules/Login/login.dart';
import 'package:mf_app/modules/Login/logincubit/logincubit.dart';

import 'package:mf_app/modules/Register/Register.dart';
import 'package:mf_app/modules/Register/Registercubit/Register.dart';
import 'package:mf_app/modules/chat%20copy.dart';
import 'package:mf_app/modules/chat.dart';
import 'package:mf_app/modules/profile/profile.dart';
import 'package:mf_app/modules/profile/profilecubit/profilecubit.dart';
import 'package:mf_app/shared/cash/Cash.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';
import 'package:mf_app/shared/network/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> firebaseonbackground(RemoteMessage message) async {
  usermodel themodel = usermodel(
      name: message.data["name"],
      profilepic: message.data["pic"],
      uid: message.data["uid"]);
  var data = message.data;
  messagemodel themessege = messagemodel(
    uid: data["uid"],
    text: message.notification!.body,
  );
  feedcubit
      .get(contextkey.currentState!.context)
      .addthetestmessege(themessege, message.data["uid"]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  var pat = await getApplicationDocumentsDirectory();
  Hive.init(pat.path);
  print(pat.path);
  Hive.registerAdapter(messagemodelAdapter());
  Hive.registerAdapter(localmodelAdapter());
  await Hive.openBox<localmodel>("nnn");

  if (await Hive.boxExists("mmesseges")) {
    print("ttttttttttttttttttttttttttt");
  }

  diohelp.init();
  await Cach.init();
  token = await FirebaseMessaging.instance.getToken();
  print("token $token");
  FirebaseMessaging.onMessage.listen((event) {
    usermodel themodel = usermodel(
        name: event.data["name"],
        profilepic: event.data["pic"],
        uid: event.data["uid"]);
    var data = event.data;

    messagemodel themessege = messagemodel(
      uid: data["uid"],
      text: event.notification!.body,
    );
    feedcubit
        .get(contextkey.currentState!.context)
        .addthetestmessege(themessege, event.data["uid"]);
    showtost(text: "one", color: Colors.red);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    usermodel themodel = usermodel(
        name: event.data["name"],
        profilepic: event.data["pic"],
        uid: event.data["uid"]);
    var data = event.data;
    messagemodel themessege = messagemodel(
      uid: data["uid"],
      text: event.notification!.body,
    );
    feedcubit
        .get(contextkey.currentState!.context)
        .addthetestmessege(themessege, event.data["uid"]);
    Navigator.of(contextkey.currentState!.context).push(
        MaterialPageRoute(builder: (context) => chatlocal(model: themodel)));
  });
  FirebaseFirestore.instance.clearPersistence();
  FirebaseMessaging.onBackgroundMessage(firebaseonbackground);

  if (Cach.cash.containsKey("dark"))
    cashdark = await Cach.getcash("dark");
  else
    Cach.putcash("dark", false);
  uid = await Cach.getcash("uid");

  if (uid != null) {
    FirebaseMessaging.instance.subscribeToTopic(uid);
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      userprofile = value.data()?["profilepic"];
      username = value.data()?["name"];
      usercover = value.data()?["cover"];
    }).catchError((error) {});
    thewidget = home();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => registercubit()),
          BlocProvider(
              create: (context) => layoutcubit()
                ..darkmodeonstatr(cashdark)
                ..gettheuserdata(context)),
          BlocProvider(create: (context) => profilecubit()..getuserdata(uid)),
          BlocProvider(create: (context) => logincubit()),
          BlocProvider(
              create: (context) => feedcubit()
                ..getallusers()
                ..getposts()),
        ],
        child: BlocConsumer<layoutcubit, layoutStats>(
            listener: (context, state) {},
            builder: (context, state) {
              layoutcubit cubit = layoutcubit.get(context);
              return MaterialApp(
                  navigatorKey: contextkey,
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: ThemeData(
                      primarySwatch: black,
                      appBarTheme: AppBarTheme(
                        iconTheme: IconThemeData(color: Colors.black),
                        color: Colors.white,
                        elevation: 0,
                        actionsIconTheme: IconThemeData(color: Colors.black),
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        selectedItemColor: Colors.black,
                        unselectedItemColor: Colors.grey,
                      ),
                      primaryColor: Colors.black),
                  darkTheme: ThemeData(
                    primaryColor: Colors.white,
                    appBarTheme: AppBarTheme(
                      backwardsCompatibility: false,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.light),
                      color: Colors.black54,
                      actionsIconTheme: IconThemeData(color: Colors.white),
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.black87,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.grey,
                    ),
                    scaffoldBackgroundColor: Colors.black45,
                    cardColor: Colors.white12,
                    cardTheme: CardTheme(
                      color: Colors.black,
                      shadowColor: Colors.white12,
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    textTheme: TextTheme(
                        caption: TextStyle(
                          color: Colors.white,
                        ),
                        subtitle1: TextStyle(
                          color: Colors.white,
                        ),
                        bodyText2: TextStyle(
                          color: Colors.white,
                        )),
                    primarySwatch: white,
                    inputDecorationTheme: InputDecorationTheme(
                      fillColor: Colors.white12,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                    ),
                  ),
                  themeMode: cubit.dark ? ThemeMode.dark : ThemeMode.light,
                  home: thewidget);
            }));
  }
}
