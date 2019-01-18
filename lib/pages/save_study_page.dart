import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/models/study.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class SaveStudyPage extends StatefulWidget {
  final Study selected;

  SaveStudyPage({Key key, this.selected}) : super(key: key);

  @override
  State createState() => SaveStudyPageState();
}

class SaveStudyPageState extends State<SaveStudyPage> {
  Study study;
  TextFormField nameField;
  TextEditingController nameController = new TextEditingController();
  TextFormField dateField;
  TextEditingController dateController = new TextEditingController();
  TextFormField typeField;
  TextEditingController typeController = new TextEditingController();
  TextFormField teamField;
  TextEditingController teamController = new TextEditingController();
  TextFormField locationField;
  TextEditingController locationController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.selected != null) {
      study = widget.selected;
      nameController.text = study.name;
      dateController.text = study.date;
      typeController.text = study.type;
      teamController.text = study.team;
      locationController.text = study.location;
    } else {
      study = new Study(
          name: "",
          date: "",
          type: "",
          team: "",
          location: "",
          donors: new List<Donor>());
    }
    nameField = new TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        filled: true,
        fillColor: ThemeData.dark().cardColor,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a name';
        }
      },
    );
    dateField = new TextFormField(
      controller: dateController,
      decoration: InputDecoration(
        labelText: 'Date',
        filled: true,
        fillColor: ThemeData.dark().cardColor,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a date';
        } else if (widget.selected == null && StudyViewModel.checkName(value)) {
          return 'Name already taken';
        }
      },
    );
    typeField = new TextFormField(
      controller: typeController,
      decoration: InputDecoration(
        labelText: 'Type',
        filled: true,
        fillColor: ThemeData.dark().cardColor,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a type';
        }
      },
    );
    teamField = new TextFormField(
      controller: teamController,
      decoration: InputDecoration(
        labelText: 'Team',
        filled: true,
        fillColor: ThemeData.dark().cardColor,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a team';
        }
      },
    );
    locationField = new TextFormField(
      controller: locationController,
      decoration: InputDecoration(
        labelText: 'Location',
        filled: true,
        fillColor: ThemeData.dark().cardColor,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a location';
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    typeController.dispose();
    teamController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: widget.selected == null
            ? Text('Add study')
            : Text('Edit ' + study.name),
        actions: <Widget>[
          widget.selected == null
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Do you wish to delete this study?'),
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
                                  StudyViewModel.studies
                                      .remove(widget.selected);
                                  await StudyViewModel.saveFile();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                )
        ],
      ),
      body: Material(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0), child: nameField),
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0), child: dateField),
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0), child: typeField),
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0), child: teamField),
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: locationField),
              ],
            )),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            study.name = nameController.text;
            study.date = dateController.text;
            study.type = typeController.text;
            study.team = teamController.text;
            study.location = locationController.text;

            if (widget.selected == null) {
              StudyViewModel.studies.add(study);
            } else {
              for (int i = 0; i < study.donors.length; i++) {
                study.donors[i].date = dateController.text;
                study.donors[i].type = typeController.text;
                study.donors[i].team = teamController.text;
                study.donors[i].location = locationController.text;
              }
            }
            await StudyViewModel.saveFile();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
