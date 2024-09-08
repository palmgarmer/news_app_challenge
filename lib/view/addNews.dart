import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_challenge/controller/googleNewsController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewsPage extends StatefulWidget {
  final String routeName = '/addnews';
  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final GoogleNewsController newsController = Get.put(GoogleNewsController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _snippetController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _thumbnail;

  @override
  void initState() {
    super.initState();
  }

  void _saveNews() async {

    final title = _titleController.text;
    final snippet = _snippetController.text;
    final thumbnail = _thumbnail;

    if (title.isEmpty || snippet.isEmpty || thumbnail == null) {
      return;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final news = {
        'title': title,
        'snippet': snippet,
        'publisher': 'You',
        'timsstamp': DateTime.now().toIso8601String(),
        'image': {
          'thumbnail': base64Encode(thumbnail.readAsBytesSync()),
        },
        'isFavorite': true,
        'hasSubnews': false,
        'subnews': [],
      };
      final newsList = prefs.getStringList('newsList') ?? [];
      newsList.add(json.encode(news));
      await prefs.setStringList('newsList', newsList);

      _titleController.clear();
      _snippetController.clear();
      setState(() {
        _thumbnail = null;
      });
    }

    Navigator.pop(context);
    newsController.fetchNews();
    Get.toNamed('/feednews');
  }

  void _selectThumbnail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnail = File(pickedFile.path);
      });
    }
  }

  Widget _buildThumbnailPreview() {
    if (_thumbnail != null) {
      return Image.file(_thumbnail!);
    } else {
      return Container();
    }
  }

  Widget _buildThumbnailButton() {
    if (_thumbnail == null) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
        ),
        onPressed: _selectThumbnail,
        icon: Icon(Icons.image),
        label: Text('Upload'),
      );
    } else {
      return Stack(
        children: [
          Image.file(_thumbnail!),
          Positioned(
            top: 4.0,
            right: 4.0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _thumbnail = null;
                });
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildForm() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Title"),
        ),
        TextField(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          maxLines: 2,
          controller: _titleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        _buildThumbnailButton(),
        SizedBox(height: 8.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Snnipet"),
        ),
        TextField(
          maxLines: 8,
          controller: _snippetController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
          ),
          onPressed: () {
            _saveNews();
          },
          icon: Icon(Icons.newspaper_outlined),
          label: Text('Publish'),
        ),
      ],
    );
  }

  // Update the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    );
  }
}
