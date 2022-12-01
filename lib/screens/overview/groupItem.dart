import 'package:attendence/base/data/groupNames.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final GroupNames groupName;
  final Function onSelect;
  const GroupItem(this.groupName, this.onSelect, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
          onPressed: () => onSelect(groupName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                groupName.name,
                style: const TextStyle(fontSize: 30),
              ),
            ],
          )),
    );
  }
}
