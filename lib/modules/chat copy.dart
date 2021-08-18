import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/models/local.dart';
import 'package:mf_app/models/messagemodel.dart';
import 'package:mf_app/models/usermodel.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedcubit.dart';
import 'package:mf_app/modules/Feed/feedcubit/feedstats.dart';
import 'package:mf_app/modules/userprofile.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/shared/constant.dart';
import 'package:mf_app/shared/network/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class chatlocal extends StatefulWidget {
  usermodel model;
  chatlocal({required this.model});

  @override
  _chatlocalState createState() => _chatlocalState();
}

class _chatlocalState extends State<chatlocal> {
  var messegecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) {
    //   feedcubit.get(context).scroll.animateTo(
    //       feedcubit.get(context).scroll.position.maxScrollExtent,
    //       duration: Duration(microseconds: 300),
    //       curve: Curves.easeInOut);
    // });
    return BlocConsumer<feedcubit, feedStats>(
        listener: (context, state) {},
        builder: (context, state) {
          feedcubit cubit = feedcubit.get(context);
          print(widget.model.uid);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  splashRadius: 18,
                  onPressed: () {
                    Navigator.pop(context);
                    cubit.mymessegemodel = [];
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryColor,
                ),
                title: InkWell(
                  onTap: () => navto(
                      context, otherprofilescreen(otherid: widget.model.uid)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage("${widget.model.profilepic}"),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${widget.model.name}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
              body: ValueListenableBuilder(
                  valueListenable: cubit.localmesseges.listenable(),
                  builder: (context, Box<localmodel> box, _) {
                    testmodell.every((element) => element.issend = true);
                    if (box.get(
                          widget.model.uid,
                        ) ==
                        null) {
                      testmodell = [];
                    } else {
                      testmodell = box
                          .get(widget.model.uid,
                              defaultValue: localmodel(thelist: testmodell))!
                          .thelist!;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: testmodell.length == 0
                                ? SizedBox()
                                : ListView.separated(
                                    controller: cubit.scroll,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (testmodell[index].uid !=
                                          widget.model.uid)
                                        return mymessage(
                                          context,
                                          testmodell.reversed.toList()[index],
                                          state,
                                        );

                                      return message(context,
                                          testmodell.reversed.toList()[index]);
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: testmodell.length),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                    inputDecorationTheme: InputDecorationTheme(
                                      hintStyle:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TextFormField(
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      controller: messegecontroller,
                                      maxLines: 5,
                                      minLines: 2,
                                      scrollPhysics:
                                          AlwaysScrollableScrollPhysics(),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "your messege..."),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadiusDirectional.circular(50)),
                                  width: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: IconButton(
                                      onPressed: () {
                                        if (messegecontroller.text.isNotEmpty) {
                                          messagemodel senddata = messagemodel(
                                              uid: uid,
                                              text: messegecontroller.text);
                                          cubit.addthetestmessege(
                                              senddata, widget.model.uid);
                                          var senderdata = cubit.usermodel2
                                              .where((element) =>
                                                  element.uid == uid)
                                              .first;
                                          diohelp.postmessegenotficarion(
                                              widget.model.uid,
                                              messegecontroller.text,
                                              senderdata.name,
                                              senderdata.profilepic,
                                              senderdata.uid);
                                          messegecontroller.clear();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  }));
        });
  }
}

message(context, messagemodel model) {
  return Align(
    alignment: Alignment.topLeft,
    child: Container(
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(15),
              topStart: Radius.circular(15),
              bottomEnd: Radius.circular(15),
            ),
            color: Colors.white10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${model.text}"),
        )),
  );
}

mymessage(
  context,
  messagemodel model,
  feedStats state,
) {
  return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(15),
            topStart: Radius.circular(15),
            bottomStart: Radius.circular(15),
          ),
          color: Colors.blue[800],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${model.text}"),
              ),
            ),
            model.isseen == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.verified),
                  )
                : SizedBox(),
            Visibility(
              visible: model.isseen == true ? false : true,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: model.issend == true
                      ? Icon(Icons.verified_outlined)
                      : Icon(Icons.lock_clock_outlined)

                  //Icon(
                  //   Icons.verified_outlined,
                  //   size: 15,
                  // );

                  ),
            )
          ],
        ),
      ));
}
