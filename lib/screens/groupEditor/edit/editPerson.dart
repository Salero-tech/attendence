import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:flutter/material.dart';

class EditPerson extends StatefulWidget {
  final Base base;
  final GroupData data;
  final int personIndex;
  final Function refresh;
  const EditPerson(this.base, this.data, this.personIndex, this.refresh,
      {super.key});

  @override
  State<EditPerson> createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  bool isEqual(Attendance status, Attendance ref) {
    return status == ref;
  }

  Future<void> reName() async {
    TextEditingController _controller = TextEditingController(
        text: widget.data.people[widget.personIndex].name);
    bool add = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('rename Person:'),
            content: TextField(
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(hintText: "name"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  add = true;
                  Navigator.of(context).pop();
                },
                child: const Text('RENAME'),
              ),
            ],
          );
        });

    if (!add) return;

    setState(() {
      widget.data.people[widget.personIndex].name = _controller.text;
    });
    await widget.base.saveGroupData(widget.data);

    _controller.dispose();
  }

  void changeAttendance(bool newBoolState, Attendance newState, int dateIndex) {
    if (newBoolState == false) return;

    setState(() {
      widget.data.people[widget.personIndex].attendanceList[dateIndex] =
          newState;
    });
    widget.base.saveGroupData(widget.data);
  }

  List<DataRow> createRows(GroupData data) {
    List<DataRow> rows = [];
    for (int i = 0; i < data.dates.length; i++) {
      rows.add(DataRow(cells: [
        DataCell(Text(
            "${data.dates[i].day}. ${data.dates[i].month}. ${data.dates[i].year}. ")),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.present, i),
          value: isEqual(data.people[widget.personIndex].attendanceList[i],
              Attendance.present),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.knownAbsent, i),
          value: isEqual(data.people[widget.personIndex].attendanceList[i],
              Attendance.knownAbsent),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.absent, i),
          value: isEqual(data.people[widget.personIndex].attendanceList[i],
              Attendance.absent),
        )),
        DataCell(Checkbox(
          onChanged: (newStatus) =>
              changeAttendance(newStatus!, Attendance.unknown, i),
          value: isEqual(data.people[widget.personIndex].attendanceList[i],
              Attendance.unknown),
        )),
      ]));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    void deletPerson() {
      widget.data.deletPerson(widget.personIndex);
      widget.base.saveGroupData(widget.data);
      Navigator.pop(context, true);
      widget.refresh();
    }

    void back() {
      Navigator.pop(context, true);
      widget.refresh();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit: ${widget.data.people[widget.personIndex].name}"),
          actions: [
            IconButton(onPressed: reName, icon: const Icon(Icons.edit)),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: deletPerson,
              icon: const Icon(Icons.delete),
              tooltip: "delet Person",
            )
          ],
          leading: IconButton(
            onPressed: back,
            icon: const Icon(Icons.arrow_back),
            tooltip: "Back",
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
                  label: Text('date'),
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
