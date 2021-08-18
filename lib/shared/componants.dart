import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaulttextform(
    {String? text,
    context,
    TextEditingController? controller,
    Widget? prefexicon,
    Widget? subfexicon,
    bool password = false,
    TextInputType? keyboardType}) {
  return TextFormField(
    style: TextStyle(color: Theme.of(context).primaryColor),
    controller: controller,
    obscureText: password,
    validator: (value) {
      if (value!.isEmpty) {
        return "this feild must not be empty";
      }
    },
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: text,
      border: OutlineInputBorder(),
      prefixIcon: prefexicon,
      suffixIcon: subfexicon,
    ),
  );
}

AppBar defaultappbar(String title, context, darkjmode) {
  return AppBar(
    title: Text(title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 20)),
    actions: [
      IconButton(
        onPressed: () {
          darkjmode;
        },
        icon: Icon(Icons.dark_mode_outlined),
      ),
    ],
  );
}

void navto(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void navandfinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

MaterialColor white = const MaterialColor(0xFFFFFFFF, <int, Color>{
  50: Color(0xFFFFFFFF),
  100: Color(0xFFFFFFFF),
  200: Color(0xFFFFFFFF),
  300: Color(0xFFFFFFFF),
  400: Color(0xFFFFFFFF),
  500: Color(0xFFFFFFFF),
  600: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
  800: Color(0xFFFFFFFF),
  900: Color(0xFFFFFFFF),
});

//0xFF000000
MaterialColor black = const MaterialColor(0xFF000000, <int, Color>{
  50: Color(0xFF000000),
  100: Color(0xFF000000),
  200: Color(0xFF000000),
  300: Color(0xFF000000),
  400: Color(0xFF000000),
  500: Color(0xFF000000),
  600: Color(0xFF000000),
  700: Color(0xFF000000),
  800: Color(0xFF000000),
  900: Color(0xFF000000),
});

void showtost({text, color}) {
  Fluttertoast.showToast(
      msg: text,
      fontSize: 16,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white);
}
