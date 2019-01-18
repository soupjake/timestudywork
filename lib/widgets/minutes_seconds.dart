import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';

class MinutesAndSeconds extends StatefulWidget {
  final double fontSize;
  final List<ValueChanged<ElapsedTime>> timerListeners;

  MinutesAndSeconds({this.fontSize, this.timerListeners});

  MinutesAndSecondsState createState() => new MinutesAndSecondsState();
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  int minutes;
  int seconds;

  @override
  void initState() {
    minutes = 0;
    seconds = 0;
    widget.timerListeners.add(onTick);
    super.initState();
  }

  @override
  void dispose(){
    widget.timerListeners.remove(onTick);
    super.dispose();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Text(minutesStr + ':' + secondsStr + ':',
        style: TextStyle(fontSize: widget.fontSize));
  }
}
