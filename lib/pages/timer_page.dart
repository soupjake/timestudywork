import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';
import 'package:timestudyapp/widgets/timer_text.dart';

class TimerPage extends StatefulWidget {
  final Donor selected;

  TimerPage({Key key, this.selected}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  Donor donor;
  List<TimerText> timers;
  TimerText waitingTimer;

  @override
  void initState() {
    donor = widget.selected;
    timers = new List<TimerText>();
    for (int i = 0; i < donor.stages.length; i++) {
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
          title: Text(donor.name),
        ),
        body: Material(
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(children: <Widget>[
                Expanded(
                    child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: donor.stages.length,
                    itemBuilder: (context, int index) {
                      return buildTaskWatch(
                          donor.stages[index].name, timers[index]);
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
            donor.measuredTime = 0;
            for (int i = 0; i < donor.stages.length; i++) {
              donor.stages[i].time = timers[i].stopwatch.elapsedMilliseconds;
              donor.measuredTime += timers[i].stopwatch.elapsedMilliseconds;
            }
            donor.waitedTime = waitingTimer.stopwatch.elapsedMilliseconds;
            donor.elapsedTime = donor.measuredTime + donor.elapsedTime;
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
