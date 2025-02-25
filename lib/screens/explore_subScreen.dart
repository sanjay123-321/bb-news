import 'dart:convert';

import 'package:bbnews/helpers/strings.dart';
import 'package:bbnews/widgets/news_template.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatSubScreen extends StatefulWidget {
  final int newsId;
  final String catName;

  const CatSubScreen({Key? key, required this.catName, required this.newsId})
      : super(key: key);

  @override
  State<CatSubScreen> createState() => _CatSubScreenState();
}

class _CatSubScreenState extends State<CatSubScreen> {
  List<Map<Object, String>> newsDataList = [];
  bool isLoading = true;
  bool isFetching = false;
  int currentPage = 1;
  bool hasMorePages = true;
  bool reachedEndOfList = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchNewsData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch more news when the user reaches the end of the list
      fetchNewsData();
    }
  }

  Future<void> fetchNewsData() async {
    try {
      if (isFetching || !hasMorePages || reachedEndOfList) {
        return; // Skip if already fetching, no more pages, or reached end
      }

      setState(() {
        isFetching = true;
      });

      final response = await http.get(
        Uri.parse(
            '${baseUrl}posts/?categories=${widget.newsId}&page=$currentPage'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        for (var item in data) {
          String title = item["title"]["rendered"]
              .toString()
              .replaceAll(RegExp(r'<[^>]*>|&#[^;]+;'), '');
          String description = item["content"]["rendered"]
              .toString()
              .replaceAll(RegExp(r'<[^>]*>|&#[^;]+;'), '');
          String timestamp = item["date"];
          List<String> parts = timestamp.split("T");

          String date = parts[0];
          String postID = (item["featured_media"]).toString();
          String imageURL = await fetchImageData(postID);

          newsDataList.add({
            "title": title,
            "description": description,
            "imageURL": imageURL,
            "postID": postID,
            "date": date,
          });
        }

        setState(() {
          currentPage++;
          isLoading = false;
          isFetching = false;
          // Check if there are more pages to fetch
          hasMorePages = data.isNotEmpty;
        });
      }
    } catch (e) {
      print('Error fetching news data: $e');
      setState(() {
        isLoading = false;
        isFetching = false;
      });
    }
  }

  Future<String> fetchImageData(String postID) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}media/$postID'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String imageURL = data["guid"]["rendered"];
        return imageURL;
      } else {
        return ''; // Return an empty string if image fetching fails
      }
    } catch (e) {
      print('Error fetching image data: $e');
      return ''; // Return an empty string in case of an error
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade200,
        centerTitle: true,
        title: Text(widget.catName),
      ),
      body: isLoading && currentPage == 1
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : newsDataList.isEmpty
              ? Center(
                  child: Text(
                    'No News Found!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: newsDataList.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < newsDataList.length) {
                      final newsData = newsDataList[index];
                      String newsTitle = newsData["title"] ?? 'No title';
                      String description =
                          newsData["description"] ?? 'No description';
                      String imageURL = newsData["imageURL"] ?? 'No Image';
                      String postID = newsData["postID"] ?? 'No PostId';
                      String? date = newsData["date"] ?? 'No Date';

                      return NewsTemplate(
                        title: newsTitle,
                        description: description,
                        urlToImage: imageURL,
                        postID: postID,
                        date: date,
                      );
                    } else {
                      // Show a loading indicator at the end of the list while fetching more data
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}
