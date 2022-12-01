import 'dart:ui';

import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:attendence/screens/groupEditor/edit/editPerson.dart';
import 'package:flutter/material.dart';

class ListViewPoeple extends StatefulWidget {
  final Base base;
  final GroupData data;
  final Future<void> Function() reFetch;
  const ListViewPoeple(this.base, this.data, this.reFetch, {Key? key})
      : super(key: key);

  @override
  State<ListViewPoeple> createState() => _ListViewPoepleState();
}

class _ListViewPoepleState extends State<ListViewPoeple> {
  List<PersonItem> getPeopleItemList(GroupData data, Function onSelect) {
    List<PersonItem> poepleItemList = [];
    for (var person in data.people) {
      poepleItemList.add(PersonItem(person, () => onSelect(person)));
    }
    return poepleItemList;
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void onSelect(Person person) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditPerson(widget.base, widget.data,
                  widget.data.getIndexOfPerson(person), refresh)));
    }

    return RefreshIndicator(
      onRefresh: widget.reFetch,
      child: ListView(
        children: getPeopleItemList(widget.data, onSelect),
      ),
    );
  }
}

class PersonItem extends StatelessWidget {
  final Function onclick;
  final Person person;
  const PersonItem(this.person, this.onclick, {Key? key}) : super(key: key);

  String getText(Person person) {
    //get number of attendance
    int attNumb = 0;
    for (var att in person.attendanceList) {
      if ((att == Attendance.present) || (att == Attendance.knownAbsent)) {
        attNumb++;
      }
    }
    return "${person.name}, ${attNumb.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () => {onclick()},
        child: Text(
          getText(person),
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
