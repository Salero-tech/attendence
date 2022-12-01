import 'package:flutter/cupertino.dart';

class GroupNames {
  final int id;
  final String name;

  const GroupNames(this.name, this.id);

  factory GroupNames.fromGroup(dynamic group) {
    return GroupNames(group['name'], group['id']);
  }

  static List<GroupNames> fromResponse(dynamic groupArray) {
    List<GroupNames> groupList = [];

    for (var group in groupArray) {
      groupList.add(GroupNames.fromGroup(group));
    }

    return groupList;
  }
}
