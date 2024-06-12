import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final Function(bool?) onChanged;

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          widget.onChanged(isChecked);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: TextStyle(color: Colors.white,fontSize: (MediaQuery.of(context).size.width > 800) ? 20 : 10,
              fontWeight: FontWeight.bold,fontFamily: 'Poppins',decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none, decorationThickness: 2.85, decorationColor: Colors.red, decorationStyle: TextDecorationStyle.solid, shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 8.0,
                  color: Color.fromARGB(125, 0, 0, 255),
                ),
              ]
          )),
          SizedBox(height: 10,),
          Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.white,
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
                widget.onChanged(isChecked);
              });
            },
          ),
        ],
      ),
    );
  }
}