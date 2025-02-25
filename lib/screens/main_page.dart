import 'dart:async';
import 'dart:convert';
import 'package:bbnews/helpers/strings.dart';
import 'package:bbnews/widgets/news_template.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class CategoryModel {
  final int id;
  final String name;
  final int catNewsCount;

  CategoryModel(
      {required this.id, required this.name, required this.catNewsCount});
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static List<CategoryModel> categories = [];

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  TabController? _tabController;
  late Completer<void> _tabControllerCompleter;

  @override
  void initState() {
    super.initState();
    _tabControllerCompleter = Completer<void>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}categories'));

      if (response.statusCode == 200) {
        List<dynamic> jsonDataList = jsonDecode(response.body);

        // Extract category names and IDs from the JSON data
        MainPage.categories = jsonDataList.map((item) {
          return CategoryModel(
            id: item['id'],
            name: item['name'].toString(),
            catNewsCount: item['count'],
          );
        }).toList();

        // Initialize the TabController here
        _tabController = TabController(
          length: MainPage.categories.length,
          vsync: this,
        );

        // Signal that the TabController is ready
        _tabControllerCompleter.complete();

        setState(() {}); // Rebuild with the updated categories
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose only if it's not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MainPage.categories.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          toolbarHeight: 0.5,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            tabs: MainPage.categories.map((category) {
              return Tab(
                text: category.name,
              );
            }).toList(),
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansGujarati',
            ),
          ),
        ),
        body: FutureBuilder<void>(
          future: _tabControllerCompleter.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              ); // Show a loading indicator while waiting for the TabController to be set up.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return TabBarView(
                controller: _tabController,
                children: MainPage.categories.map(
                  (category) {
                    return CategoryNews(category: category);
                  },
                ).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryNews extends StatefulWidget {
  final CategoryModel category;

  const CategoryNews({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Map<Object, String>> newsDataList = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int _currentPage = 1; // Track the current page
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchNewsData();
  }

  void _scrollListener() {
    // Check if the user has reached the end of the list
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Fetch new news data here
      fetchNewsData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isMounted = false;
    super.dispose();
  }

  Future<void> fetchNewsData() async {
    try {
      if (isLoading) {
        return;
      }

      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse(
          '${baseUrl}posts/?categories=${widget.category.id}&page=$_currentPage'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Extract and store news data for each item
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
          String postID =
              (item["featured_media"]).toString(); // Get the post ID here
          String imageURL = await fetchImageData(postID); // Fetch image URL
          newsDataList.add({
            "title": title,
            "description": description,
            "imageURL": imageURL,
            "postID": postID, // Add imageURL to the newsDataList
            "date": date
          });
        }
        print("Category ID: ${widget.category.id}");

        // Increment the current page after successfully fetching data
        _currentPage++;

        setState(() {});
      }
    } catch (e) {
      print('Error fetching news data: $e');
    } finally {
      if (_isMounted) {
        setState(() {
          isLoading = false;
        });
      }
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
  Widget build(BuildContext context) {
    if (isLoading && _currentPage == 1) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      );
    } else if (newsDataList.isEmpty) {
      return const Center(
        child: Text(
          'No News Found!',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: newsDataList.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < newsDataList.length) {
          final newsData = newsDataList[index];
          String newsTitle = newsData["title"] ?? 'No title';
          String description = newsData["description"] ?? 'No description';
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
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        }
      },
    );
  }
}
