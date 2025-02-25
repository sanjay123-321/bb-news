import 'package:bbnews/screens/explore_subScreen.dart';
import 'package:flutter/material.dart';
import 'package:bbnews/helpers/strings.dart';
import 'package:bbnews/screens/main_page.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    double fontSize = screenWidth * 0.05;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: screenWidth * 0.03),
            Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize),
            ),
            Divider(
              height: screenWidth * 0.04,
              thickness: 3,
              indent: 0,
              endIndent: screenWidth * 0.77,
              color: Colors.lightBlueAccent,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: MainPage.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = MainPage.categories[index];
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 4.0,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatSubScreen(
                                    catName: category.name,
                                    newsId: category.id)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.10),
                              ),
                            ),
                            Center(
                              child: Text(
                                category.name,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
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
          ],
        ),
      ),
    );
  }
}
