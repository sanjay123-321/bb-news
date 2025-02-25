import 'package:bbnews/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:bbnews/widgets/bottom_appbar.dart';
import 'package:bbnews/screens/explore_screen.dart';
import 'package:bbnews/screens/settings_screen.dart';
import 'package:bbnews/screens/saved_screen.dart';
import 'package:bbnews/screens/main_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  int newNews = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 230,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(
            "assets/images/bbnews.png",
            fit: BoxFit.cover,
          ),
        ),
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.search,
              color: Colors.red,
              size: 35,
            ),
            onTap: () {
              print('Search Clicked');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          const SizedBox(
            width: 20,
          ),
          // GestureDetector(
          //   child: Row(
          //     children: [
          //       const Icon(
          //         Icons.notifications,
          //         color: Colors.red,
          //         size: 35,
          //       ),
          //       if (newNews > 0)
          //         // Container(
          //         //   padding: const EdgeInsets.all(4),
          //         //   decoration: BoxDecoration(
          //         //     shape: BoxShape.circle,
          //         //     color: Colors.black,
          //         //   ),
          //         //   child: Text(
          //         //     newNews.toString(),
          //         //     style: const TextStyle(
          //         //       color: Colors.black,
          //         //     ),
          //         //   ),
          //         // ),
          //     ],
          //   ),
          //   onTap: () {
          //     print('Notification clicked');
          //   },
          // )
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavbar(
        onTabTapped: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const MainPage();
      case 1:
        return ExploreScreen();
      case 2:
        return const SavedScreen();
      case 3:
        return const SettingsScreen();
      case 4:
        return const SearchScreen();
      default:
        return const Center(
          child: Text('Invalid Index'),
        );
    }
  }
}
