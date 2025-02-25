import 'package:bbnews/helpers/strings.dart';
import 'package:bbnews/widgets/news_template.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<Map<Object, String>> searchResults = [];
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> searchNews(String searchTerm) async {
    final response = await http
        .get(Uri.parse('${baseUrl}posts/?search=$searchTerm&per_page=10'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<Object, String>> results = [];

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

        results.add({
          "title": title,
          "description": description,
          "imageURL": imageURL,
          "postID": postID,
          "date": date
        });
      }

      setState(() {
        searchResults = results;
      });
    } else {
      print('Error searching news: ${response.statusCode}');
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
        return '';
      }
    } catch (e) {
      print('Error fetching image data: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search News...',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                fillColor: Colors.black12,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchNews(value);
                } else {
                  setState(() {
                    searchResults.clear();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: searchResults.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      'No Results Found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final newsData = searchResults[index];
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
