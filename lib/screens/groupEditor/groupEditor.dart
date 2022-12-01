import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:attendence/screens/groupEditor/tabs/listViewDate.dart';
import 'package:attendence/screens/groupEditor/tabs/listViewPoeple.dart';
import 'package:attendence/screens/groupEditor/tabs/tableView.dart';
import 'package:flutter/material.dart';

class GroupEditor extends StatefulWidget {
  final Base base;
  GroupData data;
  final Future<void> Function() reFetch;
  GroupEditor(this.base, this.data, this.reFetch, {Key? key}) : super(key: key);

  @override
  State<GroupEditor> createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor>
    with SingleTickerProviderStateMixin {
  late Future<GroupData> futureData;
  late TabController _controller;
  Widget buttonShow = Container();
  late FloatingActionButton button = FloatingActionButton(
    onPressed: onButtonAddPress,
    child: const Icon(Icons.add),
  );

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(updateButton);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateButton() {
    setState(() {
      if (_controller.index == 0) {
        buttonShow = Container();
      } else {
        buttonShow = button;
      }
    });
  }

  void onButtonAddPress() {
    switch (_controller.index) {
      case 1:
        addPerson();
        break;
      case 2:
        pickDate();
        break;
      default:
        print("?");
    }
  }

  Future<void> addPerson() async {
    TextEditingController _controller = TextEditingController();
    bool add = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('add Person:'),
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
                child: const Text('ADD'),
              ),
            ],
          );
        });

    if (!add) return;

    setState(() {
      widget.data.addPerson(_controller.text);
    });
    await widget.base.saveGroupData(widget.data);

    _controller.dispose();
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (date == null) return;

    setState(() {
      widget.data.addDate(date);
    });
    //save to db
    await widget.base.saveGroupData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit: ${widget.data.name}'),
          bottom: TabBar(
            controller: _controller,
            tabs: const [
              Tab(icon: Icon(Icons.grid_4x4)),
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.date_range)),
            ],
          ),
        ),
        floatingActionButton: buttonShow,
        body: TabBarView(
          controller: _controller,
          children: [
            TableView(widget.data, widget.reFetch),
            ListViewPoeple(widget.base, widget.data, widget.reFetch),
            ListViewDate(widget.base, widget.data, widget.reFetch),
          ],
        ),
      ),
    );
    ;
  }
}
