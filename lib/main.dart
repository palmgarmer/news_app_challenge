import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:news_app_challenge/controller/googleNewsController.dart';
import 'package:news_app_challenge/view/addNews.dart';
import 'package:news_app_challenge/view/favNews.dart';
import 'package:news_app_challenge/view/feedNews.dart';

void main() async {
  Hive.init('newsBox');
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/feednews',
      getPages: [
        GetPage(name: '/feednews', page: () => FeednewsView()),
        GetPage(name: '/favorites', page: () => FavnewsView()),
        GetPage(name: '/addnews', page: () => AddNewsPage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
