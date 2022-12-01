import 'package:attendence/base/base.dart';
import 'package:attendence/base/data/groupNames.dart';
import 'package:attendence/screens/groupEditor/loadingEditor.dart';
import 'package:attendence/screens/overview/groupItem.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  final Base base;
  const OverviewScreen(this.base, {Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<GroupItem> groupItems = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void onSelect(GroupNames group) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadingEditor(widget.base, group)));
  }

  Future<void> getData() async {
    List<GroupNames> groups = await widget.base.getGroups();

    setState(() {
      groupItems = [];
      for (var group in groups) {
        groupItems.add(GroupItem(group, onSelect));
      }
    });
  }

  Future<void> addGroup() async {
    TextEditingController _controller = TextEditingController();
    bool add = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('add group:'),
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

    //adding
    await widget.base.createNewGroup(_controller.text, "55");
    _controller.dispose();
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Overview'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addGroup(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: groupItems,
        ),
      ),
    );
  }
}
