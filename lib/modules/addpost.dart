import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/layout/layoutcubit/cubit_layout.dart';
import 'Feed/feedcubit/feedcubit.dart';
import 'Feed/feedcubit/feedstats.dart';

class addpostscreen extends StatelessWidget {
  var addpostcontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<feedcubit, feedStats>(
        listener: (context, state) {},
        builder: (context, state) {
          feedcubit cubit = feedcubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Form(
                  key: formkey,
                  child: Row(
                    children: [
                      Container(
                        child: Theme(
                          data: ThemeData(
                            inputDecorationTheme: InputDecorationTheme(
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                filled: true,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2),
                          ),
                          child: Flexible(
                            child: TextFormField(
                              style: Theme.of(context).textTheme.bodyText2,
                              controller: addpostcontroller,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "what is in yout mind",
                                prefixIcon: Icon(Icons.post_add,
                                    color: layoutcubit.get(context).dark
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: TextButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                cubit.addpost(addpostcontroller.text);
                              }
                            },
                            child: Text(
                              "Post",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        cubit.getpostimage();
                      },
                      icon: Icon(Icons.camera_alt_sharp),
                    ),
                  ],
                ),
                cubit.postpic == null
                    ? SizedBox()
                    : Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Image(
                            image: FileImage(cubit.postpic as File),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(0.0),
                            splashRadius: 16,
                            onPressed: () {
                              cubit.removepic();
                            },
                            icon: Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
              ]),
            ),
          );
        });
  }
}
