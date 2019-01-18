import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';

class Hundreds extends StatefulWidget {
  final double fontSize;
  final List<ValueChanged<ElapsedTime>> timerListeners;

  Hundreds({this.fontSize, this.timerListeners});

  HundredsState createState() => new HundredsState();
}

class HundredsState extends State<Hundreds> {

  int hundreds;

  @override
  void initState() {
    hundreds = 0;
    widget.timerListeners.add(onTick);
    super.initState();
  }

    @override
  void dispose(){
    widget.timerListeners.remove(onTick);
    super.dispose();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return Text(hundredsStr, style: TextStyle(fontSize: widget.fontSize),);
  }
}