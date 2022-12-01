import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:attendence/screens/groupEditor/edit/editDate.dart';
import 'package:flutter/material.dart';

class ListViewDate extends StatefulWidget {
  final GroupData data;
  final Base base;
  final Future<void> Function() reFetch;
  const ListViewDate(this.base, this.data, this.reFetch, {Key? key})
      : super(key: key);

  @override
  State<ListViewDate> createState() => _ListViewDateState();
}

class _ListViewDateState extends State<ListViewDate> {
  List<DateItem> getDateItemList(GroupData data, Function onSelect) {
    List<DateItem> dateItemList = [];
    for (var date in data.dates) {
      dateItemList.add(DateItem(date, () => onSelect(date)));
    }
    return dateItemList;
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void onSelect(DateTime date) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditDate(widget.base, widget.data,
                  widget.data.getIndexOfDate(date), refresh)));
    }

    return RefreshIndicator(
      onRefresh: widget.reFetch,
      child: ListView(
        children: getDateItemList(widget.data, onSelect),
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  final Function onclick;
  final DateTime date;
  const DateItem(this.date, this.onclick, {Key? key}) : super(key: key);

  String getText(DateTime date) {
    return "${date.day}. ${date.month}. ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: () => {onclick()},
        child: Text(
          getText(date),
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
