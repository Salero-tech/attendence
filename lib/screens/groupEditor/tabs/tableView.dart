import 'package:attendence/base/data/groupData.dart';
import 'package:flutter/material.dart';

class TableView extends StatelessWidget {
  final GroupData data;
  final Future<void> Function() reFetch;
  const TableView(this.data, this.reFetch, {Key? key}) : super(key: key);

  List<DataColumn> createColumns(GroupData data) {
    List<DataColumn> columns = [
      const DataColumn(
        label: Text('Date'),
      ),
    ];
    for (var persons in data.people) {
      columns.add(DataColumn(
        label: Text(persons.name),
      ));
    }

    return columns;
  }

  List<DataRow> createRows(GroupData data) {
    List<DataRow> rows = [];
    //add Dates
    for (var date in data.dates) {
      rows.add(DataRow(
          cells: [DataCell(Text("${date.day}. ${date.month}. ${date.year}"))]));
    }

    //Add people
    for (int i = 0; i < data.people.length; i++) {
      for (var j = 0; j < data.people[i].attendanceList.length; j++) {
        rows[j].cells.add(DataCell(Text(GroupData
            .AttendanceToString[data.people[i].attendanceList[j].index])));
      }
    }

    return rows;
  }

  Future<void> onrefresh() async {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: reFetch,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              // datatable widget
              columns: createColumns(data),
              rows: createRows(data),
            ),
          )
        ],
      ),
    );
  }
}
