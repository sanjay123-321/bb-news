import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavbar extends StatefulWidget {
  final void Function(int) onTabTapped;

  BottomNavbar({required this.onTabTapped});
  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          iconSize: 30,
          backgroundColor: Colors.white,
          haptic: true,
          tabBorderRadius: 15,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 250),
          gap: 5,
          activeColor: Colors.blue.shade600,
          color: Colors.grey,
          tabBackgroundColor: Colors.lightBlue.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          tabs: [
            GButton(
              padding: EdgeInsets.all(15),
              icon: Icons.home_outlined,
              text: 'Home',
              onPressed: () {
                widget.onTabTapped(
                    0); // Notify the parent widget about the tab change
              },
            ),
            GButton(
              padding: EdgeInsets.all(15),
              icon: Icons.grid_view,
              text: 'Categories',
              onPressed: () {
                widget.onTabTapped(
                    1); // Notify the parent widget about the tab change
              },
            ),
            GButton(
              padding: EdgeInsets.all(15),
              icon: Icons.search,
              text: 'Search',
              onPressed: () {
                widget.onTabTapped(
                    4); // Notify the parent widget about the tab change
              },
            ),
            // GButton(
            //   padding: EdgeInsets.all(15),
            //   icon: Icons.favorite_border,
            //   text: 'Saved',
            //   onPressed: () {
            //     widget.onTabTapped(
            //         2); // Notify the parent widget about the tab change
            //   },
            // ),
            // GButton(
            //   padding: EdgeInsets.all(15),
            //   icon: Icons.person_2_outlined,
            //   text: 'Settings',
            //   onPressed: () {
            //     widget.onTabTapped(
            //         3); // Notify the parent widget about the tab change
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
