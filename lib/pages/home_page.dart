import 'package:flutter/material.dart';
import 'package:timestudyapp/pages/save_study_page.dart';
import 'package:timestudyapp/pages/study_page.dart';
import 'package:timestudyapp/viewmodels/study_viewmodel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('TimeStudyApp'),
      ),
      body: Material(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: StudyViewModel.studies.length > 0
                    ? ListView.builder(
                        itemCount: StudyViewModel.studies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                            title: Text(StudyViewModel.studies[index].name),
                            children: <Widget>[
                              ListView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                physics: ClampingScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Date:'),
                                        Text(StudyViewModel.studies[index].date)
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Type:'),
                                        Text(StudyViewModel.studies[index].type)
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Team:'),
                                        Text(StudyViewModel.studies[index].team)
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Location:'),
                                        Text(StudyViewModel
                                            .studies[index].location)
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Donors:'),
                                        Text(StudyViewModel
                                            .studies[index].donors.length
                                            .toString())
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SaveStudyPage(
                                                          selected:
                                                              StudyViewModel
                                                                      .studies[
                                                                  index])));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudyPage(
                                                        selected: StudyViewModel
                                                            .studies[index],
                                                      )));
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          );
                        })
                    : Center(
                        child: Text('Add a study using the circle button!')))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveStudyPage(
                        selected: null,
                      )));
        },
      ),
    );
  }
}
