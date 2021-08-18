import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/modules/profile/profilecubit/profilecubit.dart';
import 'package:mf_app/modules/profile/profilecubit/profilestats.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mf_app/shared/constant.dart';

var editnamecontroller = TextEditingController();
var editbiocontroller = TextEditingController();
var formkey = GlobalKey<FormState>();

class profilescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<profilecubit, profileStats>(
        listener: (context, state) {},
        builder: (context, state) {
          profilecubit cubit = profilecubit.get(context);
          var profilepic = cubit.editpic;
          var coverpic = cubit.editcover;
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  splashRadius: 18,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(cubit.editmode ? "Edit Profile" : 'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 20)),
                actions: [
                  IconButton(
                      splashRadius: 18,
                      onPressed: () {
                        cubit.entereditmode();
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              body: cubit.mymodel?.name == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              state is loading
                                  ? LinearProgressIndicator(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    )
                                  : SizedBox(),
                              Column(
                                children: [
                                  Container(
                                    height: 170,
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              coverpic == null
                                                  ? Image.network(
                                                      usercover,
                                                      height: 140,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                    )
                                                  : Image(
                                                      image: FileImage(
                                                        coverpic,
                                                      ),
                                                      height: 140,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                              Visibility(
                                                visible: cubit.editmode,
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .circular(50)),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      cubit.getcoverimage();
                                                    },
                                                    icon:
                                                        Icon(Icons.camera_alt),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    iconSize: 16,
                                                    splashRadius: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              radius: 45,
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundImage: profilepic ==
                                                        null
                                                    ? NetworkImage(userprofile)
                                                    : FileImage(profilepic)
                                                        as ImageProvider,
                                                onBackgroundImageError: (error,
                                                        stackTrace) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                              ),
                                            ),
                                            Visibility(
                                              visible: cubit.editmode,
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(50)),
                                                child: IconButton(
                                                  onPressed: () {
                                                    cubit.getimage();
                                                  },
                                                  icon: Icon(Icons.camera_alt),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  iconSize: 16,
                                                  splashRadius: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  cubit.uploadpic
                                      ? TextButton(
                                          onPressed: () {
                                            cubit.uploadprofileppic();
                                          },
                                          child: Text(
                                            "Update Profile pic",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ))
                                      : SizedBox(),
                                  cubit.uploadcover
                                      ? TextButton(
                                          onPressed: () {
                                            cubit.uploadcoverppic();
                                          },
                                          child: Text(
                                            "Update cover",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ))
                                      : SizedBox(),
                                  cubit.editmode
                                      ? editname(context)
                                      : Text("${cubit.mymodel?.name}"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  cubit.editmode
                                      ? editbio(context)
                                      : Text(
                                          "${cubit.mymodel?.bio}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: cubit.editmode,
                                    child: TextButton(
                                        onPressed: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            cubit.editprofile(
                                                name: editnamecontroller.text,
                                                bio: editbiocontroller.text);
                                          }
                                        },
                                        child: Text(
                                          "Update Profile",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
        });
  }
}

Widget editname(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            filled: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            labelStyle: Theme.of(context).textTheme.bodyText2),
      ),
      child: defaulttextform(
        context: context,
        controller: editnamecontroller,
        text: "Edit your name",
      ),
    ),
  );
}

Widget editbio(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            filled: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            labelStyle: Theme.of(context).textTheme.bodyText2),
      ),
      child: defaulttextform(
        context: context,
        controller: editbiocontroller,
        text: "Edit your bio",
      ),
    ),
  );
}
