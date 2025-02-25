import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/strings.dart';

class Comment {
  String content;
  String author;
  String userIcon;
  String date;
  String time;

  Comment(
      {required this.content,
      required this.author,
      required this.userIcon,
      required this.date,
      required this.time});
}

class ChatScreen extends StatefulWidget {
  final String image;
  final String postID;
  final String title;

  const ChatScreen({
    Key? key,
    required this.image,
    required this.postID,
    required this.title,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();
  bool isInputFocused = false;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    print(widget.postID);
    List<Comment> fetchedComments = await fetchCommentData(widget.postID);
    setState(() {
      comments = fetchedComments;
    });
  }

  void addComment() {
    String newComment = commentController.text;
    setState(() {
      comments.add(Comment(
          content: newComment,
          author: "No Username",
          userIcon: "your_user_icon_url_here",
          time: 'time of post',
          date: 'date of post'));
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110.0), // Set the desired height
          child: CustomAppBar(imageURL: widget.image, title: widget.title),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                if (comments.isEmpty)
                  const Center(
                    child: Text(
                      "No Comments",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                else
                  Column(
                    children: comments
                        .map((comment) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        comment.userIcon),
                                  ),
                                  title: Text(
                                    comment.content,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  subtitle: Text(
                                    "${comment.author} ${comment.date} ${comment.time}",
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
              ]),
            ),
          ],
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.black.withOpacity(0.5),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     padding: const EdgeInsets.all(10),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: TextField(
        //             cursorColor: Colors.white,
        //             controller: commentController,
        //             decoration: InputDecoration(
        //               hintStyle:
        //                   const TextStyle(color: Colors.white, fontSize: 17),
        //               hintText: 'Add Comment...',
        //               focusedBorder: OutlineInputBorder(
        //                 borderSide: const BorderSide(color: Colors.white),
        //                 borderRadius: BorderRadius.circular(10.0),
        //               ),
        //               enabledBorder: OutlineInputBorder(
        //                 borderSide: const BorderSide(color: Colors.grey),
        //                 borderRadius: BorderRadius.circular(10.0),
        //               ),
        //             ),
        //             onChanged: (text) {
        //               setState(() {
        //                 isInputFocused = text.isNotEmpty;
        //               });
        //             },
        //           ),
        //         ),
        //         IconButton(
        //           icon: Icon(Icons.send,
        //               color: isInputFocused ? Colors.white : Colors.grey),
        //           onPressed: isInputFocused ? addComment : null,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

Future<List<Comment>> fetchCommentData(String postID) async {
  try {
    final response =
        await http.get(Uri.parse('${baseUrl}comments?post=$postID'));
    if (response.statusCode == 200) {
      List<Comment> comments = [];
      List<dynamic> data = jsonDecode(response.body);

      for (var commentData in data) {
        String content = commentData["content"]["rendered"];
        String author = commentData["author_name"];
        String userIcon = commentData["author_avatar_urls"]["24"];
        String timestamp = commentData["date"];
        List<String> parts = timestamp.split("T");

        String date = parts[0];
        String time = parts[1];

        content =
            content.toString().replaceAll("<p>", "").replaceAll("</p>", "");

        Comment comment = Comment(
            content: content,
            author: author,
            userIcon: userIcon,
            time: time,
            date: date);

        comments.add(comment);
      }
      return comments;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching comment data: $e');
    return [];
  }
}

class CustomAppBar extends StatelessWidget {
  String imageURL = "";
  String title = "";

  CustomAppBar({super.key, required this.imageURL, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors
                    .black, // Set the color to make the back arrow visible
              ),
              const SizedBox(
                width: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageURL,
                  width: 80,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "All Comments",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
