import 'package:flutter/material.dart';



class AppText extends StatelessWidget {
  String? data;
  double? size;
  Color? color;
  FontWeight? fw;
  TextAlign? align;
  AppText({Key? key, required this.data, this.size, this.color, this.fw,this.align=TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Text(

      data.toString(),
      textAlign: align,
      style: TextStyle(fontSize: size, color:theme.hintColor,fontWeight: fw,fontFamily: "Roboto"),
    );
  }
}
