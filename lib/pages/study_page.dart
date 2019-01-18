import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:timestudyapp/models/task.dart';
import 'package:timestudyapp/pages/task_page.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class StudyPage extends StatefulWidget {
  final Study selected;

  StudyPage({Key key, this.selected}) : super(key: key);

  @override
  State createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage> {
  Study study;
  TextField nameField;
  TextEditingController nameController = new TextEditingController();

  @override
  void initState() {
    study = widget.selected;
    nameField = new TextField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        filled: true,
        fillColor: ThemeData.dark().canvasColor,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(study.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.email),
            onPressed: () async {
              await StudyViewModel.exportData(study.name);
            },
          )
        ],
      ),
      body: Material(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: study.donors.length > 0
                    ? ListView.builder(
                        itemCount: study.donors.length,
                        itemBuilder: (context, int donorIndex) {
                          return ExpansionTile(
                            title: Text(study.donors[donorIndex].name),
                            children: <Widget>[
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                physics: ClampingScrollPhysics(),
                                itemCount:
                                    study.donors[donorIndex].tasks.length,
                                itemBuilder: (context, int taskIndex) {
                                  return ListTile(
                                    title: Text(study.donors[donorIndex]
                                        .tasks[taskIndex].name),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('M: ' +
                                            StudyViewModel.milliToElapsedString(
                                                study
                                                    .donors[donorIndex]
                                                    .tasks[taskIndex]
                                                    .measuredTime)),
                                        Text('W: ' +
                                            StudyViewModel.milliToElapsedString(
                                                study
                                                    .donors[donorIndex]
                                                    .tasks[taskIndex]
                                                    .waitedTime)),
                                        Text('E: ' +
                                            StudyViewModel.milliToElapsedString(
                                                study
                                                    .donors[donorIndex]
                                                    .tasks[taskIndex]
                                                    .elapsedTime)),
                                      ],
                                    ),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TaskPage(
                                                  selected: study
                                                      .donors[donorIndex]
                                                      .tasks[taskIndex])));
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text(
                                                'Are you sure you wish to delete this donor?'),
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
                                                  setState(() {
                                                    study.donors
                                                        .removeAt(donorIndex);
                                                  });

                                                  await StudyViewModel
                                                      .saveFile();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                },
                              )
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Text('Add a donor using the circle button!')))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Add donor'),
                    content: nameField,
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
                          if (nameController.text != '') {
                            setState(() {
                              study.donors.add(new Donor(
                                  name: nameController.text,
                                  date: study.date,
                                  type: study.type,
                                  team: study.team,
                                  location: study.location,
                                  tasks:
                                      List<Task>.from(StudyViewModel.tasks)));
                            });
                            await StudyViewModel.saveFile();
                            nameController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ));
        },
      ),
    );
  }
}
