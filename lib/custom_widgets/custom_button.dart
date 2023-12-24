import 'package:flutter/material.dart';

Widget CustomButton(String name,double width,double height,fontColor, color,double namesize) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Text(
        name,
        style:  TextStyle(
          color: fontColor, fontWeight: FontWeight.bold, fontSize: namesize,),
      ),
    ),
  );
}