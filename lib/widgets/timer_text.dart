import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timestudyapp/models/elapsed_time.dart';
import 'package:timestudyapp/widgets/hundreds.dart';
import 'package:timestudyapp/widgets/minutes_seconds.dart';

class TimerText extends StatefulWidget {
  final Stopwatch stopwatch;

  TimerText({this.stopwatch});

  TimerTextState createState() => new TimerTextState();
}

class TimerTextState extends State<TimerText> {
  Timer timer;
  int milliseconds;
  List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];

  @override
  void initState() {
    timer = new Timer.periodic(Duration(milliseconds: 30), callback);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    timerListeners = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != widget.stopwatch.elapsedMilliseconds) {
      milliseconds = widget.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for(final listener in timerListeners){
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          MinutesAndSeconds(fontSize: 24.0, timerListeners: timerListeners,),
          Hundreds(fontSize: 24.0, timerListeners: timerListeners,),
      ],
    );
  }
}