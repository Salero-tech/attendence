import 'dart:convert';

import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class EditDate extends StatefulWidget {
  final Base base;
  final GroupData data;
  final int dateIndex;
  final Function refresh;
  const EditDate(this.base, this.data, this.dateIndex, this.refresh,
      {super.key});

  @override
  State<EditDate> createState() => _EditDateState();
}

class _EditDateState extends State<EditDate> {
  bool isEqual(Attendance status, Attendance ref) {
    return status == ref;
  }

  void changeAttendance(
      bool newBoolState, Attendance newState, int personIndex) {
    if (newBoolState == false) return;

    setState(() {
      widget.data.people[personIndex].attendanceList[widget.dateIndex] =
          newState;
    });
    widget.base.saveGroupData(widget.data);
  }

  List<DataRow> createRows(GroupData data) {
    List<DataRow> rows = [];
    for (int i = 0; i < data.people.length; i++) {
      rows.add(DataRow(cells: [
        DataCell(Text(data.people[i].name)),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.present, i),
          value: isEqual(data.people[i].attendanceList[widget.dateIndex],
              Attendance.present),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.knownAbsent, i),
          value: isEqual(data.people[i].attendanceList[widget.dateIndex],
              Attendance.knownAbsent),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.absent, i),
          value: isEqual(data.people[i].attendanceList[widget.dateIndex],
              Attendance.absent),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.unknown, i),
          value: isEqual(data.people[i].attendanceList[widget.dateIndex],
              Attendance.unknown),
        )),
      ]));
    }
    return rows;
  }

  Future<void> reName() async {
    DateTime? date = await showDatePicker(
      //locale: const Locale('de', 'CH'),
      context: context,
      initialDate: widget.data.dates[widget.dateIndex],
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (date == null) return;

    setState(() {
      widget.data.dates[widget.dateIndex] = date;
    });
    //save to db
    await widget.base.saveGroupData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    void delete() {
      widget.data.deleteDate(
          widget.data.getIndexOfDate(widget.data.dates[widget.dateIndex]));
      Navigator.pop(context, true);
      widget.refresh();
      widget.base.saveGroupData(widget.data);
    }

    void back() {
      Navigator.pop(context, true);
      widget.refresh();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Edit: ${widget.data.dates[widget.dateIndex].day}. ${widget.data.dates[widget.dateIndex].month}. ${widget.data.dates[widget.dateIndex].year}"),
          actions: [
            IconButton(onPressed: reName, icon: const Icon(Icons.edit)),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: delete,
              icon: const Icon(Icons.delete),
              tooltip: "delete date",
            )
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: back,
            tooltip: "back",
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              // datatable widget
              columns: const [
                // column to set the name
                DataColumn(
                  label: Text('name'),
                ),
                DataColumn(
                  label: Text('present'),
                ),
                DataColumn(
                  label: Text('sign out'),
                ),
                DataColumn(
                  label: Text('absent'),
                ),
                DataColumn(
                  label: Text('unknown'),
                ),
              ],

              rows: createRows(widget.data),
            ),
          ),
        ));
  }
}
