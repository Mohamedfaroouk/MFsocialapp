import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:mf_app/layout/layoutcubit/cubit_layout.dart';
import 'package:mf_app/layout/layoutcubit/layoutstats.dart';
import 'package:mf_app/models/local.dart';
import 'package:mf_app/modules/profile/profile.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';
import 'package:permission_handler/permission_handler.dart';

ReceivePort _port = ReceivePort();

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Widget build(BuildContext context) {
    return BlocConsumer<layoutcubit, layoutStats>(
        listener: (context, state) {},
        builder: (context, state) {
          layoutcubit cubit = layoutcubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text("${cubit.titles[cubit.myindex]}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 20)),
              actions: [
                TextButton(
                    onPressed: () {
                      cubit.logout(context);
                    },
                    child: Text("Logout")),
                IconButton(
                  splashRadius: 18,
                  onPressed: () {
                    cubit.darkmode();
                  },
                  icon: Icon(Icons.dark_mode_outlined),
                ),
                IconButton(
                  splashRadius: 18,
                  onPressed: () async {
                    final status = await Permission.storage.request();
                    if (status.isGranted) {
                      final taskid = await FlutterDownloader.enqueue(
                        url: backup!,
                        savedDir: "/data/user/0/com.example.mf_app/app_flutter",
                        fileName: "nnn.hive",
                      ).then((value) async {
                        Hive.box<localmodel>("nnn");
                      }).then((value) async =>
                          await Hive.openBox<localmodel>("nnn"));
                      setState(() {});
                      ;
                    }
                  },
                  icon: Icon(Icons.download),
                ),
                IconButton(
                  splashRadius: 18,
                  onPressed: () async {
                    firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child("backup/$uid/nnn.hive")
                        .putFile(File(
                            "/data/user/0/com.example.mf_app/app_flutter/nnn.hive"))
                        .then((value) => value.ref.getDownloadURL())
                        .then((value) => backup = value);
                  },
                  icon: Icon(Icons.upload),
                ),
                // IconButton(
                //   splashRadius: 18,
                //   onPressed: () {},
                //   icon: Icon(Icons.search_outlined),
                // ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: InkWell(
                      onTap: () {
                        navto(context, profilescreen());
                      },
                      child: CircleAvatar(
                        radius: 16,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(100)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CircleAvatar(
                              radius: 16,
                              child: Image.network(
                                userprofile,
                                height: 33,
                                width: 33,
                                errorBuilder: (context, error, stackTrace) =>
                                    CircularProgressIndicator(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                fit: BoxFit.cover,
                              ),
                            )),
                      )),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.circle_notifications_rounded),
                    label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.post_add), label: "Add Post"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.supervised_user_circle), label: "Friends"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Setting")
              ],
              onTap: (value) {
                cubit.changescreen(value);
              },
              currentIndex: cubit.myindex,
            ),
            body: cubit.screens[cubit.myindex],
          );
        });
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
