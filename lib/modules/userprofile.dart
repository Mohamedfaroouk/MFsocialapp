import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mf_app/models/postmodel.dart';
import 'package:mf_app/models/usermodel.dart';

import 'package:mf_app/modules/profile/profilecubit/profilecubit.dart';
import 'package:mf_app/modules/profile/profilecubit/profilestats.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mf_app/shared/constant.dart';

class otherprofilescreen extends StatefulWidget {
  String? otherid;
  otherprofilescreen({required this.otherid});

  @override
  _otherprofilescreenState createState() =>
      _otherprofilescreenState(otherid: otherid);
}

class _otherprofilescreenState extends State<otherprofilescreen> {
  String? otherid;
  _otherprofilescreenState({required this.otherid});
  @override
  void initState() {
    profilecubit.get(context).getotheruserdata(otherid);
    profilecubit.get(context).getpostsprofile(otherid);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<profilecubit, profileStats>(
        listener: (context, state) {},
        builder: (context, state) {
          profilecubit cubit = profilecubit.get(context);

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
                title: Text("",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 20)),
              ),
              body: cubit.model?.name == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
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
                                            Image.network(
                                              "${cubit.model?.cover}",
                                              height: 140,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                            )
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            radius: 45,
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  "${cubit.model?.profilepic}"),
                                              onBackgroundImageError:
                                                  (error, stackTrace) => Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text("${cubit.model?.name}"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${cubit.model?.bio}",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                            ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => postsprofile(
                                  context,
                                  index,
                                  cubit.posts[index],
                                  cubit.model!),
                              separatorBuilder: (context, index) => SizedBox(),
                              itemCount: cubit.posts.length,
                            ),
                          ],
                        ),
                      ),
                    ));
        });
  }
}

Widget postsprofile(context, index, postmodel posts, usermodel model) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage("${model.profilepic}"),
                    radius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${posts.name}'),
                        Text(
                            "${DateFormat('h:m d/M/y').format(posts.date!.toDate())}",
                            style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            posts.pic == null
                ? SizedBox()
                : Image(
                    fit: BoxFit.cover,
                    height: 200.0,
                    width: double.infinity,
                    image: NetworkImage(posts.pic as String),
                    errorBuilder: (context, error, stackTrace) => SizedBox(),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${posts.text}'),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Text(
                    "${profilecubit.get(context).likes[index].toString()}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  splashRadius: 24,
                  onPressed: () {
                    profilecubit.get(context).changeLikeState(
                        profilecubit.get(context).postid[index], index);
                  },
                  iconSize: 22,
                  constraints: BoxConstraints(minWidth: 11),
                  padding: const EdgeInsets.all(5),
                  icon: profilecubit.get(context).iliked[index]
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_outline),
                ),
                // IconButton(
                //   splashRadius: 24,
                //   padding: const EdgeInsetsDirectional.all(5),
                //   onPressed: () {},
                //   icon: Icon(Icons.mode_comment_outlined),
                //   iconSize: 22,
                //   constraints: BoxConstraints(minWidth: 11),
                // ),
                // Spacer(),
                // IconButton(
                //   splashRadius: 24,
                //   padding: const EdgeInsets.all(
                //     8,
                //   ),
                //   onPressed: () {},
                //   icon: Icon(Icons.bookmark_outline_rounded),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
