import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/pages/timer_page.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class DonorPage extends StatefulWidget {
  final Donor selected;

  DonorPage({Key key, this.selected}) : super(key: key);

  @override
  State createState() => DonorPageState();
}

class DonorPageState extends State<DonorPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Donor donor;
  TextField noteField;
  TextEditingController noteController = new TextEditingController();

  @override
  void initState() {
    donor = widget.selected;
    noteField = new TextField(
      controller: noteController,
      decoration: InputDecoration(
        labelText: 'Note',
        filled: true,
        fillColor: ThemeData.dark().canvasColor,
      ),
    );
    noteController.text = donor.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(donor.name),
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
                              donor.note = noteController.text;
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
                itemCount: donor.stages.length,
                itemBuilder: (context, int stageIndex) {
                  return ExpansionTile(
                    title: Text(donor.stages[stageIndex].name),
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        physics: ClampingScrollPhysics(),
                        itemCount: donor.stages[stageIndex].attributes.length,
                        itemBuilder: (context, int attributeIndex) {
                          return CheckboxListTile(
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(donor.stages[stageIndex]
                                .attributes[attributeIndex].name),
                            value: donor.stages[stageIndex]
                                .attributes[attributeIndex].value,
                            onChanged: (bool value) {
                              setState(() {
                                donor.stages[stageIndex]
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
                                  donor.stages[stageIndex].time))
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
                    Text(
                        StudyViewModel.milliToElapsedString(donor.measuredTime),
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
                    Text(StudyViewModel.milliToElapsedString(donor.waitedTime),
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
                    Text(StudyViewModel.milliToElapsedString(donor.elapsedTime),
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
                  builder: (context) => TimerPage(selected: donor),
                  fullscreenDialog: true));
        },
      ),
    );
  }
}
