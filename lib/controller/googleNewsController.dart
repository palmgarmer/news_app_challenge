import 'package:get/get.dart';
import 'package:news_app_challenge/model/googleNewsModel.dart';
import 'package:news_app_challenge/service/googleNewsService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GoogleNewsController extends GetxController {
  var newsList = <GoogleNewsModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading(true);
      final news = await GoogleNewsService.getNews();
      final savedNewsList = <GoogleNewsModel>[];
      await loadFavoriteStatus(news);
      // await loadSavedNews();
      // newsList.assignAll(savedNewsList);
      newsList.assignAll(news);
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchFavoriteNews() async {
    try {
      isLoading(true);
      final news = await GoogleNewsService.getNews();
      await loadFavoriteStatus(news);
      newsList
          .assignAll(news.where((news) => news.isFavorite == true).toList());
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleFavoriteStatus(GoogleNewsModel news) async {
    if (news.isFavorite != null) {
      news.isFavorite = !(news.isFavorite!);
      await saveFavoriteStatus(news);
      newsList.refresh();
    }
  }

  Future<void> saveFavoriteStatus(GoogleNewsModel news) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteStatus = prefs.getString('favoriteStatus') ?? '{}';
    final favoriteMap = json.decode(favoriteStatus) as Map<String, dynamic>;
    favoriteMap[news.title!] = news.isFavorite;
    await prefs.setString('favoriteStatus', json.encode(favoriteMap));
  }

  Future<void> loadFavoriteStatus(List<GoogleNewsModel> newsList) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteStatus = prefs.getString('favoriteStatus') ?? '{}';
    final favoriteMap = json.decode(favoriteStatus) as Map<String, dynamic>;
    for (var news in newsList) {
      if (favoriteMap.containsKey(news.title)) {
        news.isFavorite = favoriteMap[news.title];
      }
    }
  }

  Future<void> loadSavedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNews = prefs.getStringList('newsList') ?? [];
    final List<dynamic> newsJson = json.decode(savedNews.toString());
    final savedNewsList =
        newsJson.map((item) => GoogleNewsModel.fromJson(item)).toList();
    // final savedNewsList =
    //     newsJson.map((item) => GoogleNewsModel.fromJson(item)).toList();
    // newsList.assignAll(savedNewsList);
  }
}
