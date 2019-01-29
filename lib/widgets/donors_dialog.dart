import 'package:flutter/material.dart';
import 'package:timestudyapp/models/donor.dart';

class DonorsDialog extends StatefulWidget {
  final List<Donor> selected;

  DonorsDialog({Key key, this.selected}) : super(key: key);

  DonorsDialogState createState() => new DonorsDialogState();
}

class DonorsDialogState extends State<DonorsDialog> {
  List<Donor> donors;
  List<bool> bools;

  @override
  void initState() {
    donors = widget.selected;
    bools = new List<bool>();
    for (int i = 0; i < donors.length; i++) {
      bools.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select donors'),
      content: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Flexible(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: donors.length,
              itemBuilder: (context, int index) {
                return CheckboxListTile(
                    title: Text(donors[index].name),
                    activeColor: Theme.of(context).accentColor,
                    value: bools[index],
                    onChanged: (bool value) {
                      setState(() {
                        bools[index] = value;
                      });
                    });
              },
            ))
          ])),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FlatButton(
          child: Text('Accept'),
          onPressed: () {
            List<Donor> temp = new List<Donor>();
            for (int i = 0; i < donors.length; i++) {
              if (bools[i]) {
                temp.add(donors[i]);
              }
            }
            Navigator.of(context).pop(temp);
          },
        ),
      ],
    );
  }
}
