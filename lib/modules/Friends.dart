import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedstats.dart';
import 'package:mf_app/modules/chat%20copy.dart';

import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'Feed/feedcubit/feedcubit.dart';

class friendsscreen extends StatelessWidget {
  RefreshController refresh = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<feedcubit, feedStats>(
        listener: (context, state) {},
        builder: (context, state) {
          feedcubit cubit = feedcubit.get(context);
          return SmartRefresher(
              controller: refresh,
              enablePullDown: true,
              enablePullUp: true,
              onLoading: () => cubit.onloadingusers(refresh),
              onRefresh: () => cubit.onrefreshusers(refresh),
              header: WaterDropMaterialHeader(
                backgroundColor: Colors.grey[400],
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              footer: CustomFooter(
                builder: (context, mode) {
                  Widget? body;
                  if (mode == LoadStatus.idle) {
                    body = Text("Pull up to load");
                  }
                  if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  }
                  if (mode == LoadStatus.failed) {
                    body = Text("Load faild");
                  }
                  if (mode == LoadStatus.canLoading) {
                    body = Text("load more");
                  } else {
                    Text("No more data");
                  }
                  return Container(
                    height: 55,
                    child: Center(
                      child: body,
                    ),
                  );
                },
              ),
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      users(context, cubit.usermodel2[index]),
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: cubit.usermodel2.length));
        });
  }
}

Widget users(context, usermodel usermodel) {
  return usermodel.uid == uid
      ? SizedBox()
      : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(),
                height: 50,
                child: InkWell(
                  onTap: () {
                    navto(context, chatlocal(model: usermodel));
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage("${usermodel.profilepic}"),
                        ),
                      ),
                      Text("${usermodel.name}"),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
}
