// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mf_app/models/messagemodel.dart';
// import 'package:mf_app/models/usermodel.dart';
// import 'package:mf_app/modules/Feed/feedcubit/feedcubit.dart';
// import 'package:mf_app/modules/Feed/feedcubit/feedstats.dart';
// import 'package:mf_app/modules/userprofile.dart';
// import 'package:mf_app/shared/componants.dart';
// import 'package:mf_app/shared/constant.dart';
// import 'package:mf_app/shared/network/dio.dart';

// class chat extends StatefulWidget {
//   usermodel model1;
//   chat({required this.model1});

//   @override
//   _chatState createState() => _chatState(model: model1);
// }

// class _chatState extends State<chat> {
//   usermodel model;
//   _chatState({required this.model});
//   var messegecontroller = TextEditingController();
//   @override
//   void initState() {
//     feedcubit.get(context).readmessge(model.uid);
//     feedcubit.get(context).mymessegemodel = [];
//     // TODO: implement initState
//     feedcubit.get(context).getmessage(resiverid: model.uid);
//     super.initState();
//   }

//   @override
//   build(BuildContext context) {
//     return BlocConsumer<feedcubit, feedStats>(listener: (context, state) {
//       if (state is sendloadingsucess)
//         feedcubit.get(context).theicon = Icon(Icons.lock_clock);
//     }, builder: (context, state) {
//       feedcubit cubit = feedcubit.get(context);
//       return Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               splashRadius: 18,
//               onPressed: () {
//                 Navigator.pop(context);
//                 cubit.mymessegemodel = [];
//               },
//               icon: Icon(Icons.arrow_back),
//               color: Theme.of(context).primaryColor,
//             ),
//             title: InkWell(
//               onTap: () =>
//                   navto(context, otherprofilescreen(otherid: model.uid)),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundImage: NetworkImage("${model.profilepic}"),
//                   ),
//                   SizedBox(
//                     width: 8,
//                   ),
//                   Text(
//                     '${model.name}',
//                     style: Theme.of(context).textTheme.bodyText2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: cubit.mymessegemodel.length == 0
//                       ? SizedBox()
//                       : ListView.separated(
//                           reverse: true,
//                           physics: AlwaysScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             if (cubit.mymessegemodel[index].uid != model.uid)
//                               return mymessage(
//                                 context,
//                                 cubit.mymessegemodel[index],
//                                 state,
//                               );

//                             return message(
//                                 context, cubit.mymessegemodel[index]);
//                           },
//                           separatorBuilder: (context, index) => SizedBox(
//                                 height: 10,
//                               ),
//                           itemCount: cubit.mymessegemodel.length),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Theme(
//                         data: ThemeData(
//                           inputDecorationTheme: InputDecorationTheme(
//                             hintStyle: Theme.of(context).textTheme.bodyText2,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: TextFormField(
//                             style: Theme.of(context).textTheme.bodyText2,
//                             controller: messegecontroller,
//                             maxLines: 5,
//                             minLines: 2,
//                             scrollPhysics: AlwaysScrollableScrollPhysics(),
//                             decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: "your messege..."),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                         decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadiusDirectional.circular(50)),
//                         width: 50,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: IconButton(
//                             onPressed: () {
//                               if (messegecontroller.text.isNotEmpty)
//                                 cubit.sendmessage(
//                                     text: messegecontroller.text,
//                                     resiverid: model.uid);
//                               var senderdata = cubit.usermodel2
//                                   .where((element) => element.uid == uid)
//                                   .first;
//                               diohelp.postmessegenotficarion(
//                                   model.uid,
//                                   messegecontroller.text,
//                                   senderdata.name,
//                                   senderdata.profilepic,
//                                   senderdata.uid);
//                               messegecontroller.clear();
//                             },
//                             icon: Icon(
//                               Icons.send_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         )),
//                   ],
//                 )
//               ],
//             ),
//           ));
//     });
//   }
// }

// message(context, messagemodel model) {
//   return Align(
//     alignment: Alignment.topLeft,
//     child: Container(
//         width: 160,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadiusDirectional.only(
//               topEnd: Radius.circular(15),
//               topStart: Radius.circular(15),
//               bottomEnd: Radius.circular(15),
//             ),
//             color: Colors.white10),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text("${model.text}"),
//         )),
//   );
// }

// mymessage(
//   context,
//   messagemodel model,
//   feedStats state,
// ) {
//   return Align(
//       alignment: Alignment.topRight,
//       child: Container(
//         width: 160,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadiusDirectional.only(
//             topEnd: Radius.circular(15),
//             topStart: Radius.circular(15),
//             bottomStart: Radius.circular(15),
//           ),
//           color: Colors.blue[800],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text("${model.text}"),
//               ),
//             ),
//             model.isseen == true
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(Icons.verified),
//                   )
//                 : SizedBox(),
//             Visibility(
//               visible: model.isseen == true ? false : true,
//               child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: model.issend == true
//                       ? Icon(Icons.verified_outlined)
//                       : Icon(Icons.lock_clock_outlined)

//                   //Icon(
//                   //   Icons.verified_outlined,
//                   //   size: 15,
//                   // );

//                   ),
//             )
//           ],
//         ),
//       ));
// }
