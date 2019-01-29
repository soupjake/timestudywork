import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';
import 'package:timestudyapp/pages/timer_page.dart';

class DonorTimerPage extends StatefulWidget {
  final List<Donor> selected;
  final String title;

  DonorTimerPage({Key key, this.selected, this.title}) : super(key: key);

  DonorTimerPageState createState() => new DonorTimerPageState();
}

class DonorTimerPageState extends State<DonorTimerPage> {
  List<Donor> donors;

  @override
  void initState() {
    donors = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Material(
          child: Scrollbar(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: donors.length,
                        itemBuilder: (context, int index) {
                          double screenWidth =
                              MediaQuery.of(context).size.width;

                          return Container(
                              width: donors.length > 1
                                  ? screenWidth / 2
                                  : screenWidth,
                              child: TimerPage(selected: donors[index]));
                        },
                      ),
                    ),
                  ]))),
        ));
  }
}
