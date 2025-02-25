import 'package:flutter/material.dart';
import 'package:bbnews/utils/layout_utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bbnews/screens/news_detail_screen.dart';

class NewsTemplate extends StatefulWidget {
  String title = '';
  String urlToImage = '';
  String description = '';
  String postID = '';
  String date = '';

  NewsTemplate(
      {required this.title,
      required this.urlToImage,
      required this.description,
      required this.postID,
      required this.date});

  @override
  State<NewsTemplate> createState() => _NewsTemplateState();
}

class _NewsTemplateState extends State<NewsTemplate> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(
                    heading: widget.title,
                    image: widget.urlToImage,
                    news: widget.description,
                    postID: widget.postID,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check if the URL is not fetched
                widget.urlToImage.isNotEmpty
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: mediaQuery.size.width * 0.40,
                          height: mediaQuery.size.height * 0.17,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.urlToImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : // Placeholder when URL is not fetched
                    Container(
                        width: mediaQuery.size.width * 0.40,
                        height: mediaQuery.size.height * 0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white, // Placeholder color
                        ),
                        child: Image.asset('assets/images/no_image.png'),
                      ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: LayoutUtils.cardText(
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * textScaleFactor,
                      ),
                    ),
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14 * textScaleFactor,
                      ),
                    ),
                    widget.date,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
