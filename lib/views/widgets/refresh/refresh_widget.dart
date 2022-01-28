// imports nativos do flutter
import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {

  final String message;
  const RefreshWidget({ Key? key, required this.message }) : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(""),
              ),
            ),
          ],
        ),
        Positioned(
          child: Center(
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
