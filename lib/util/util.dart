import 'package:flutter/material.dart';

import 'color.dart';

const String fonts = 'Freesentation';
final DateTime today = DateTime.now();

double sizew(context) => MediaQuery.sizeOf(context).width;

double sizeh(context) => MediaQuery.sizeOf(context).height;

snack(context, text, icon, {act = null}) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: .only(topLeft: .circular(20), topRight: .circular(20)),
    ),
    backgroundColor: primary,
    action: act,
    content: Row(
      spacing: 12,
      children: [
        Icon(icon, size: 25, color: Colors.white),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: .bold),
        ),
      ],
    ),
  ),
);

fieldStyle(hint) => InputDecoration(
  hintText: hint,
  filled: true,
  fillColor: fill,
  contentPadding: .symmetric(horizontal: 12, vertical: 10),
  border: OutlineInputBorder(
    borderRadius: .circular(4),
    borderSide: BorderSide(color: border, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: .circular(4),
    borderSide: BorderSide(color: focusBorder, width: 1),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: .circular(4),
    borderSide: BorderSide(color: errorBorder, width: 1),
  ),
);
