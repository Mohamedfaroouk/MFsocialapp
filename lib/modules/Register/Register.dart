import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mf_app/modules/Register/Registercubit/Register.dart';
import 'package:mf_app/shared/componants.dart';
import 'package:mf_app/layout/layoutcubit/cubit_layout.dart';

import 'Registercubit/Registerstats.dart';

class registerscreen extends StatelessWidget {
  var email = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<registercubit, registerStats>(
        listener: (context, state) {},
        builder: (context, state) {
          registercubit cubit = registercubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    layoutcubit.get(context).darkmode();
                  },
                  icon: Icon(Icons.dark_mode_outlined),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: defaulttextform(
                                        context: context,
                                        controller: name,
                                        text: "Name",
                                        prefexicon: Icon(Icons.mail_outline,
                                            color: layoutcubit.get(context).dark
                                                ? Colors.white
                                                : Colors.grey),
                                        password: false,
                                        keyboardType:
                                            TextInputType.emailAddress),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: defaulttextform(
                                        context: context,
                                        controller: email,
                                        text: "Email",
                                        prefexicon: Icon(Icons.mail_outline,
                                            color: layoutcubit.get(context).dark
                                                ? Colors.white
                                                : Colors.grey),
                                        password: false,
                                        keyboardType:
                                            TextInputType.emailAddress),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: defaulttextform(
                                        context: context,
                                        controller: password,
                                        text: "password",
                                        prefexicon: Icon(Icons.lock,
                                            color: layoutcubit.get(context).dark
                                                ? Colors.white
                                                : Colors.grey),
                                        password: true,
                                        keyboardType:
                                            TextInputType.visiblePassword),
                                  ),
                                  MaterialButton(
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          cubit.reg(
                                            email.text,
                                            password.text,
                                            context,
                                            name.text,
                                          );
                                        }
                                      },
                                      child: state is regloading
                                          ? CircularProgressIndicator()
                                          : Text("Registe now",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2))
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
