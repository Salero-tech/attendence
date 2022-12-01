class GroupData {
  static const List<String> AttendanceToString = [
    "unknown",
    "present",
    "sign out",
    "absent"
  ];
  final int id;
  String name;
  List<DateTime> dates;
  List<Person> people;

  GroupData(this.id, this.name, this.dates, this.people);

  factory GroupData.fromResponse(dynamic response) {
    int id = response['id'];
    String name = response['name'];
    dynamic data = response['data'];
    List<DateTime> dates = respToDateArray(data['dates']);
    List<Person> people = respToPersonArray(data['people']);
    return GroupData(id, name, dates, people);
  }

  static List<DateTime> respToDateArray(dynamic datesData) {
    List<DateTime> dates = [];

    for (var date in datesData) {
      dates.add(DateTime.parse(date));
    }
    return dates;
  }

  static List<Person> respToPersonArray(dynamic peopleData) {
    List<Person> people = [];
    for (var person in peopleData) {
      people.add(Person.fromResp(person));
    }
    return people;
  }

  void addDate(DateTime date) {
    int index = dates.length;

    for (int i = 0; i < dates.length; i++) {
      if ((date.difference(dates[i]).isNegative)) {
        index = i;
        break;
      }
    }

    dates.insert(index, date);

    for (var person in people) {
      person.attendanceList.insert(index, Attendance.unknown);
    }
  }

  void deleteDate(int dateIndex) {
    dates.removeAt(dateIndex);

    for (int i = 0; i < people.length; i++) {
      people[i].attendanceList.removeAt(dateIndex);
    }
  }

  void addPerson(String name) {
    List<Attendance> attArray = [];

    for (int i = 0; i < dates.length; i++) {
      attArray.add(Attendance.unknown);
    }

    people.add(Person(name, attArray));
  }

  void deletPerson(int personIndex) {
    people.removeAt(personIndex);
  }

  dynamic toJson() {
    List<String> dateListJson = [];
    for (var date in dates) {
      dateListJson.add(date.toString());
    }

    List<dynamic> peopleListJson = [];
    for (var person in people) {
      peopleListJson.add(person.toJson());
    }

    dynamic data = {
      'dates': dateListJson,
      'people': peopleListJson,
    };

    return data;
  }

  int getIndexOfDate(DateTime date) {
    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == date) return i;
    }
    throw ("date not in list");
  }

  int getIndexOfPerson(Person person) {
    for (int i = 0; i < people.length; i++) {
      if (people[i] == person) return i;
    }

    throw ("person not in list");
  }
}

enum Attendance { unknown, present, knownAbsent, absent }

class Person {
  String name;
  List<Attendance> attendanceList;

  Person(this.name, this.attendanceList);

  factory Person.fromResp(dynamic data) {
    String name = data['name'];
    List<Attendance> attendenceList = [];
    for (var att in data['attendance']) {
      attendenceList.add(indexToAttendance(att));
    }

    return Person(name, attendenceList);
  }

  static Attendance indexToAttendance(int data) {
    switch (data) {
      case 1:
        return Attendance.present;
      case 2:
        return Attendance.knownAbsent;
      case 3:
        return Attendance.absent;
      default:
        return Attendance.unknown;
    }
  }

  dynamic toJson() {
    List<int> attendanceArray = [];

    for (var att in attendanceList) {
      attendanceArray.add(att.index);
    }

    return {"name": name, "attendance": attendanceArray};
  }
}
