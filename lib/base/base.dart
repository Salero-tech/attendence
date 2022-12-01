import 'package:attendence/base/data/groupData.dart';
import 'package:attendence/base/data/groupNames.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Base {
  final supabaseClient =
      SupabaseClient(dotenv.get('API_URL'), dotenv.get('API_KEY'));

  Future<bool> createNewGroup(String name, String passwd) async {
    var resp = await supabaseClient.from("attendenceData").insert({
      "name": name,
      "passwd": passwd,
      "data": {"dates": [], "people": []}
    }).execute();
    print(resp.data);
    return false;
  }

  Future<List<GroupNames>> getGroups() async {
    var test = await supabaseClient.functions.invoke("getNames");
    print(test.data);
    var resp = await supabaseClient
        .from("attendenceData")
        .select('id, name')
        .order('name', ascending: true)
        .execute();

    return GroupNames.fromResponse(resp.data);
  }

  Future<GroupData> getGroupData(int id) async {
    var resp = await supabaseClient
        .from("attendenceData")
        .select()
        .filter('id', 'eq', id)
        .execute();
    return GroupData.fromResponse(resp.data[0]);
  }

  Future<void> saveGroupData(GroupData data) async {
    var resp = await supabaseClient
        .from("attendenceData")
        .update({'data': data.toJson()})
        .eq('id', data.id)
        .execute();
  }
}
