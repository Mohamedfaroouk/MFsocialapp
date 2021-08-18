import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mf_app/models/postmodel.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedcubit.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedstats.dart';
import 'package:mf_app/modules/userprofile.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class homescreen extends StatelessWidget {
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
              onLoading: () => cubit.onloading(refresh),
              onRefresh: () => cubit.onrefresh(refresh),
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
                shrinkWrap: true,
                itemBuilder: (context, index) => posts(
                    context, index, cubit.posts[index], cubit.profilepics),
                separatorBuilder: (context, index) => SizedBox(),
                itemCount: cubit.posts.length,
              ));
        });
  }
}

Widget posts(context, index, postmodel posts, Map profilepics) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  navto(context, otherprofilescreen(otherid: posts.uid));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "${feedcubit.get(context).profilepics[posts.uid]}"),
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
                    "${posts.likes.toString()}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  splashRadius: 24,
                  onPressed: () {
                    feedcubit
                        .get(context)
                        .changeLikeState(posts.postid, index, posts);
                  },
                  iconSize: 22,
                  constraints: BoxConstraints(minWidth: 11),
                  padding: const EdgeInsets.all(5),
                  icon: posts.iliked!
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
