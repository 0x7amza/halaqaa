import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget textField({
  required String hintText,
  height = 50.0,
  isHintCentered = true,
  title = '',
  required controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: 5.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        height: height.toDouble(),
        child: TextField(
          controller: controller,
          expands: true,
          maxLines: null,

          keyboardType: TextInputType.multiline,
          textAlignVertical: isHintCentered
              ? TextAlignVertical.center
              : TextAlignVertical.top,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 1.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    ],
  );
}
