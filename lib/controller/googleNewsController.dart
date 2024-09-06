import 'package:news_app_challenge/model/googleNewsModel.dart';
import 'package:news_app_challenge/service/googleNewsService.dart';

class GoogleNewsController {
  final GoogleNewsService _service = GoogleNewsService();

  Future<List<GoogleNewsModel>> fetchNews() async {
    try {
      final news = await GoogleNewsService.loadFallbackData();
      return news;
    } catch (e) {
      // Handle any errors that occur during the fetch process
      print('Error fetching news: $e');
      return [];
    }
  }
}
