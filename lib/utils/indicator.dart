import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  Color color;
  String text;
  bool isSquare;
  double size;
  Color textColor;

  Indicator({
    required Key key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 14,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: widget.isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: widget.color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          widget.text,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: widget.textColor),
        )
      ],
    );
  }
}
