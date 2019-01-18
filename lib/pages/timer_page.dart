import 'package:flutter/material.dart';
import 'package:timestudyapp/models/task.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';
import 'package:timestudyapp/widgets/timer_text.dart';

class TimerPage extends StatefulWidget {
  final Task selected;

  TimerPage({Key key, this.selected}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Task task;
  List<TimerText> timers;
  TimerText waitingTimer;

  @override
  void initState() {
    task = widget.selected;
    timers = new List<TimerText>();
    for (int i = 0; i < task.stages.length; i++) {
      timers.add(new TimerText(
        stopwatch: new Stopwatch(),
      ));
    }
    waitingTimer = new TimerText(
      stopwatch: new Stopwatch(),
    );
    super.initState();
  }

  @override
  void dispose() {
    timers = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(task.name),
        ),
        body: Material(
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(children: <Widget>[
                Expanded(
                    child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: task.stages.length,
                    itemBuilder: (context, int index) {
                      return buildTaskWatch(
                          task.stages[index].name, timers[index]);
                    },
                  ),
                )),
                Divider(),
                Center(child: buildTaskWatch('Waiting', waitingTimer))
              ])),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            task.measuredTime = 0;
            for (int i = 0; i < task.stages.length; i++) {
              task.stages[i].time = timers[i].stopwatch.elapsedMilliseconds;
              task.measuredTime += timers[i].stopwatch.elapsedMilliseconds;
            }
            task.waitedTime = waitingTimer.stopwatch.elapsedMilliseconds;
            task.elapsedTime = task.measuredTime + task.elapsedTime;
            await StudyViewModel.saveFile();
            Navigator.of(context).pop();
          },
        ));
  }

  Widget buildTaskWatch(String title, TimerText timerText) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(title, style: TextStyle(fontSize: 20.0))),
        timerText,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          FlatButton(
            child: Text('Reset'),
            textColor: Theme.of(context).accentColor,
            onPressed: timerText.stopwatch.isRunning
                ? null
                : () {
                    timerText.stopwatch.reset();
                  },
          ),
          FlatButton(
            child: timerText.stopwatch.isRunning ? Text('Stop') : Text('Start'),
            textColor: Theme.of(context).accentColor,
            onPressed: () {
              if (timerText.stopwatch.isRunning) {
                setState(() {
                  timerText.stopwatch.stop();
                });
              } else {
                setState(() {
                  timerText.stopwatch.start();
                });
              }
            },
          ),
        ])
      ],
    );
  }
}
