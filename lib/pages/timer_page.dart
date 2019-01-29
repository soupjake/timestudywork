import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';
import 'package:timestudyapp/widgets/timer_text.dart';

class TimerPage extends StatefulWidget {
  final Donor selected;

  TimerPage({Key key, this.selected}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage>
    with AutomaticKeepAliveClientMixin {
  Donor donor;
  List<TimerText> timers;
  TimerText waitingTimer;
  bool saved;

  @override
  bool get wantKeepAlive => true;

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
    saved = false;
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
        body: Column(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            donor.name,
            style: TextStyle(fontSize: 20.0),
          )),
      Divider(),
      Expanded(
          child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: donor.stages.length,
          itemBuilder: (context, int index) {
            return buildTaskWatch(donor.stages[index].name, timers[index]);
          },
        ),
      )),
      Divider(),
      Center(child: buildTaskWatch('Waiting', waitingTimer)),
      RaisedButton(
        color: Theme.of(context).accentColor,
        child: saved ? Text('Saved') : Text('Save'),
        onPressed: saved
            ? null
            : () async {
                donor.measuredTime = 0;
                donor.elapsedTime = 0;
                for (int i = 0; i < donor.stages.length; i++) {
                  donor.stages[i].time =
                      timers[i].stopwatch.elapsedMilliseconds;
                  donor.measuredTime += timers[i].stopwatch.elapsedMilliseconds;
                }
                donor.waitedTime = waitingTimer.stopwatch.elapsedMilliseconds;
                donor.elapsedTime = donor.measuredTime + donor.waitedTime;
                await StudyViewModel.saveFile();
                setState(() {
                  saved = true;
                });
              },
      )
    ]));
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
                    setState(() {
                      saved = false;
                    });
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
