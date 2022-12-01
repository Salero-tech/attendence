import 'package:attendence/aninimation/loading.dart';
import 'package:attendence/base/base.dart';
import 'package:attendence/screens/groupEditor/groupEditor.dart';
import 'package:flutter/material.dart';
import 'package:attendence/base/data/groupData.dart';
import 'package:attendence/base/data/groupNames.dart';

class LoadingEditor extends StatefulWidget {
  final Base base;
  final GroupNames group;
  const LoadingEditor(this.base, this.group, {super.key});

  @override
  State<LoadingEditor> createState() => _LoadingEditorState();
}

class _LoadingEditorState extends State<LoadingEditor> {
  late GroupData data;
  bool gotData = false;

  Future<void> reFetch() async {
    data = await widget.base.getGroupData(widget.group.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<GroupData> dataFuture = widget.base.getGroupData(widget.group.id);
    return FutureBuilder<GroupData>(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot<GroupData> snapshot) {
          if (snapshot.hasData) {
            if (!gotData) {
              data = snapshot.data!;
              gotData = true;
            }
            return GroupEditor(widget.base, data, reFetch);
          } else {
            return const LoadingAnimation();
          }
        });
  }
}
