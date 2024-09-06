import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:news_app_challenge/model/googleNewsModel.dart';

class GoogleNewsService {
  // static const String _baseUrl = 'https://google-news13.p.rapidapi.com';

  // static Future<List<GoogleNewsModel>> getNews() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$_baseUrl/business?lr=en-US'),
  //       headers: {
  //         'accept': 'application/json',
  //         'x-rapidapi-ua': 'RapidAPI-Playground',
  //         'x-rapidapi-host': 'google-news13.p.rapidapi.com',
  //         'x-rapidapi-key': 'YOUR_API_KEY', // Replace with your actual key
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       List<dynamic> jsonData = json.decode(response.body);
  //       return jsonData.map((json) => GoogleNewsModel.fromJson(json)).toList();
  //     } else {
  //       print('Response body: ${response.body}');
  //       return _loadFallbackData();
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //     return _loadFallbackData();
  //   }
  // }

  static Future<List<GoogleNewsModel>> loadFallbackData() async {
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
