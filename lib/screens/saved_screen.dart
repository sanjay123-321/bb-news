import 'package:flutter/material.dart';
import 'login_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.05;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize),
          ),
          Divider(
            height: screenWidth * 0.04,
            thickness: 3,
            indent: 0,
            endIndent: screenWidth * 0.8,
            color: Colors.lightBlueAccent,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWindow(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20), // Adjust the value for the desired roundness
                ), // Text color
              ),
              child: Text('Sign in to continue'),
            ),
          )
        ],
      ),
    );
  }
}
