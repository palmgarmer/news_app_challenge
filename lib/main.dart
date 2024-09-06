import 'package:flutter/material.dart';
import 'package:news_app_challenge/model/googleNewsModel.dart';
import 'package:news_app_challenge/service/googleNewsService.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
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
    _fetchNews();
  }

  void _fetchNews() async {
    try {
      var news = await GoogleNewsService.loadFallbackData();
    } catch (e) {
      print('Failed to fetch news: $e');
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'NEWS APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GoogleNewsModel> _news = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() async {
    try {
      List<GoogleNewsModel> news = await GoogleNewsService.loadFallbackData();
      setState(() {
        _news = news;
      });
    } catch (e) {
      print('Failed to fetch news: $e');
    }
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_pageController.page! < _news.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[800],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: _news.isEmpty
            ? Text('No news available')
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _news.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[200],
                          child: InkWell(
                            onTap: () {
                              Uri? newsUrl = _news[index].newsUrl != null
                                  ? Uri.parse(_news[index].newsUrl!)
                                  : null;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _news[index].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _news[index].snippet,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 8),
                                  if (_news[index].images != null)
                                    Image.network(
                                      _news[index].images!.thumbnail,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width, // Set width to screen width
                                    ),
                                  SizedBox(height: 8),
                                  Text(
                                    _news[index].publisher,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        onPressed: _previousPage,
                        iconSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios_outlined),
                        onPressed: _nextPage,
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Do nothing
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}
