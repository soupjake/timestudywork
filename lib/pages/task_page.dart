import 'package:flutter/material.dart';
import 'package:timestudyapp/models/task.dart';
import 'package:timestudyapp/pages/timer_page.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class TaskPage extends StatefulWidget {
  final Task selected;

  TaskPage({Key key, this.selected}) : super(key: key);

  @override
  State createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Task task;
  TextField noteField;
  TextEditingController noteController = new TextEditingController();

  @override
  void initState() {
    task = widget.selected;
    noteField = new TextField(
      controller: noteController,
      decoration: InputDecoration(
        labelText: 'Note',
        filled: true,
        fillColor: ThemeData.dark().canvasColor,
      ),
    );
    noteController.text = task.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(task.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.comment),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Task note'),
                        content: noteField,
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Accept'),
                            onPressed: () async {
                              task.note = noteController.text;
                              await StudyViewModel.saveFile();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await StudyViewModel.saveFile();
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Saved!'),
                duration: Duration(milliseconds: 2000),
                backgroundColor: Theme.of(context).primaryColor,
              ));
            },
          ),
        ],
      ),
      body: Material(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: task.stages.length,
                itemBuilder: (context, int stageIndex) {
                  return ExpansionTile(
                    title: Text(task.stages[stageIndex].name),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        physics: ClampingScrollPhysics(),
                        itemCount: task.stages[stageIndex].attributes.length,
                        itemBuilder: (context, int attributeIndex) {
                          return CheckboxListTile(
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(task.stages[stageIndex]
                                .attributes[attributeIndex].name),
                            value: task.stages[stageIndex]
                                .attributes[attributeIndex].value,
                            onChanged: (bool value) {
                              setState(() {
                                task.stages[stageIndex]
                                    .attributes[attributeIndex].value = value;
                              });
                            },
                          );
                        },
                      ),
                      ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 40.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Time: '),
                              Text(StudyViewModel.milliToElapsedString(
                                  task.stages[stageIndex].time))
                            ],
                          )),
                    ],
                  );
                },
              )),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 64.0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Measured time:', style: TextStyle(fontSize: 16.0)),
                    Text(StudyViewModel.milliToElapsedString(task.measuredTime),
                        style: TextStyle(fontSize: 16.0))
                  ],
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 64.0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Waited time:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(StudyViewModel.milliToElapsedString(task.waitedTime),
                        style: TextStyle(fontSize: 16.0))
                  ],
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 64.0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Elapsed time:', style: TextStyle(fontSize: 16.0)),
                    Text(StudyViewModel.milliToElapsedString(task.elapsedTime),
                        style: TextStyle(fontSize: 16.0))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.timer),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TimerPage(selected: task),
                  fullscreenDialog: true));
        },
      ),
    );
  }
}
