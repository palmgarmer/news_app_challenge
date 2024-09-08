import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:news_app_challenge/controller/googleNewsController.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class FavnewsView extends StatelessWidget {
  final String routeName = '/favorites';
  FavnewsView({super.key});
  final GoogleNewsController newsController = Get.put(GoogleNewsController());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAVORITES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[800],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[800],
              ),
              child: const Text(
                'NEWS APP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('News'),
              onTap: () {
                Navigator.pop(context);
                newsController.fetchNews();
                Get.toNamed('/feednews');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('My Articles'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/addnews');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Obx(
          () {
            if (newsController.isLoading.value) {
              return CircularProgressIndicator();
            } else if (newsController.newsList.isEmpty) {
              return Text('No news available');
            } else {
              return Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: newsController.newsList.length,
                    itemBuilder: (context, index) {
                      var news = newsController.newsList[index];
                      var date =
                          DateTime.fromMillisecondsSinceEpoch(news.timestamp!);
                      var formattedDate = timeago.format(date);
                      return GestureDetector(
                        onTap: () {
                          Uri? newsUrl = Uri.tryParse(news.newsUrl ?? '');
                          launchUrl(newsUrl!);
                        },
                        child: Card(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  news.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                if (news.images != null)
                                  Image.network(
                                    news.images!.thumbnail,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                Text(
                                  news.snippet,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      news.publisher + ' : ' + formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        news.isFavorite ?? false
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: news.isFavorite ?? false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        newsController
                                            .toggleFavoriteStatus(news);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_back_ios_outlined),
                                        onPressed: () {
                                          if (_pageController.page! > 0) {
                                            _pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        iconSize: 15,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_forward_ios_outlined),
                                        onPressed: () {
                                          if (_pageController.page! <
                                              newsController.newsList.length -
                                                  1) {
                                            _pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        iconSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
