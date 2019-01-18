import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:timestudyapp/pages/donor_page.dart';
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
                child: ListView.builder(
              itemCount: study.tasks.length,
              itemBuilder: (context, int taskIndex) {
                return ExpansionTile(
                  title: Text(study.tasks[taskIndex].name),
                  children: <Widget>[
                    study.tasks[taskIndex].donors.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            physics: ClampingScrollPhysics(),
                            itemCount: study.tasks[taskIndex].donors.length,
                            itemBuilder: (context, int donorIndex) {
                              return ListTile(
                                title: Text(study
                                    .tasks[taskIndex].donors[donorIndex].name),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('M: ' +
                                        StudyViewModel.milliToElapsedString(
                                            study
                                                .tasks[taskIndex]
                                                .donors[donorIndex]
                                                .measuredTime)),
                                    Text('W: ' +
                                        StudyViewModel.milliToElapsedString(
                                            study
                                                .tasks[taskIndex]
                                                .donors[donorIndex]
                                                .waitedTime)),
                                    Text('E: ' +
                                        StudyViewModel.milliToElapsedString(
                                            study
                                                .tasks[taskIndex]
                                                .donors[donorIndex]
                                                .elapsedTime)),
                                  ],
                                ),
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DonorPage(
                                              selected: study.tasks[taskIndex]
                                                  .donors[donorIndex])));
                                },
                                onLongPress: () async {
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
                                                child: Text('Delete'),
                                                textColor: Colors.red,
                                                onPressed: () async {
                                                  setState(() {
                                                    study
                                                        .tasks[taskIndex].donors
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
                              );
                            },
                          )
                        : Text('Add a donor using the + button below!'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        setState(() {
                          study.tasks[taskIndex].donors.add(new Donor(
                              name: generateName(taskIndex),
                              date: study.date,
                              type: study.type,
                              team: study.team,
                              location: study.location,
                              measuredTime: 0,
                              waitedTime: 0,
                              elapsedTime: 0,
                              note: '',
                              stages: StudyViewModel.copyStages(
                                  study.tasks[taskIndex])));
                        });
                        await StudyViewModel.saveFile();
                      },
                    )
                  ],
                );
              },
            ))
          ],
        ),
      )),
    );
  }

  String generateName(int taskIndex) {
    String name = 'Donor ';
    if (study.tasks[taskIndex].donors.length > 0) {
      int lastNameInt = int.parse(study.tasks[taskIndex]
          .donors[study.tasks[taskIndex].donors.length - 1].name
          .substring(study
                  .tasks[taskIndex]
                  .donors[study.tasks[taskIndex].donors.length - 1]
                  .name
                  .length -
              1));
      name += (lastNameInt + 1).toString();
    } else {
      name += '1';
    }
    return name;
  }
}
