import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:news_app_challenge/model/googleNewsModel.dart';
import 'package:hive/hive.dart';

class GoogleNewsService {
  static const String _baseUrl = 'https://google-news13.p.rapidapi.com';

  static Future<List<GoogleNewsModel>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/business?lr=en-US'),
        headers: {
          'accept': 'application/json',
          'x-rapidapi-ua': 'RapidAPI-Playground',
          'x-rapidapi-host': 'google-news13.p.rapidapi.com',
          'x-rapidapi-key':
              'aaf03001dbmsh9b8621e22f4d831p1fe1c7jsneedacb34d994',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> items = jsonData['items'];
        List<GoogleNewsModel> newsList =
            items.map((json) => GoogleNewsModel.fromJson(json)).toList();
        var box = await Hive.openBox<GoogleNewsModel>('newsBox');
        await box.clear();
        await box.addAll(newsList);
        return newsList;
      } else {
        // print('Response body: ${response.body}');
        return loadMockupData();
      }
    } catch (e) {
      // print('Error occurred: $e');
      throw Exception('Failed to fetch news');
    }
  }

  static Future<List<GoogleNewsModel>> loadMockupData() async {
    try {
      String jsonString =
          await rootBundle.loadString('lib/utils/response.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> items = jsonData['items'];
      return items.map((json) => GoogleNewsModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading fallback data: $e');
      throw Exception('Failed to fetch news');
    }
  }
}
