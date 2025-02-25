import 'dart:convert';

import 'package:bbnews/helpers/strings.dart';
import 'package:bbnews/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class NewsDetail extends StatefulWidget {
  final String image;
  final String heading;
  final String news;
  final String postID;

  const NewsDetail({
    Key? key,
    required this.image,
    required this.heading,
    required this.news,
    required this.postID,
  }) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  double appBarOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: screenHeight * 0.26,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.image,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
            ),
            backgroundColor: Colors.black26,
            leading: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black45,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
            ),
            floating: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                color: Colors.black.withOpacity(appBarOpacity),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.heading,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Text(
                        widget.news,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      // floatingActionButton: FutureBuilder<String>(
      //   future: numberOfComments(widget.postID),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       // Return a loading indicator or some placeholder
      //       return CircularProgressIndicator();
      //     } else if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     } else {
      //       // Convert the number of comments to an integer
      //       int numberOfComments = int.parse(snapshot.data ?? '0');

      //       // Show the FloatingActionButton only if the number of comments is greater than 0
      //       if (numberOfComments > 0) {
      //         return SizedBox(
      //           child: FloatingActionButton.extended(
      //             label: Text("Comments ($numberOfComments)"),
      //             splashColor: Colors.blue.shade300,
      //             enableFeedback: true,
      //             elevation: 4,
      //             backgroundColor: Colors.blue.shade300,
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => ChatScreen(
      //                     image: widget.image,
      //                     postID: widget.postID,
      //                     title: widget.heading,
      //                   ),
      //                 ),
      //               );
      //             },
      //             icon: const Icon(Icons.message_outlined),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(8.0),
      //             ),
      //           ),
      //         );
      //       } else {
      //         // Return an empty container if the number of comments is 0
      //         return Container();
      //       }
      //     }
      //   },
      // ),
    );
  }
}

// Future<String> numberOfComments(String postID) async {
//   try {
//     final response =
//         await http.get(Uri.parse('${baseUrl}comments?post=$postID'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);

//       // Get the number of comments and convert it to a string
//       String numberOfComments = data.length.toString();

//       return numberOfComments;
//     } else {
//       // Handle errors or empty responses
//       throw Exception(
//           'Failed to fetch comments. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Error fetching comments: $e');
//   }
// }
