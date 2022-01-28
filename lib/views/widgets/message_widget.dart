// imports nativos do flutter
import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar(context, content, color) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}