import 'package:hive_flutter/hive_flutter.dart';

class Newsdata {
  List todoList = [];
  var newsBox = Hive.box('newsBox');
  void createInitailData() {}

  void LoadData() {
    newsBox = newsBox.get("newsBox");
  }

  void updateData() {
    newsBox.put("newsBox", newsBox);
  }
}
