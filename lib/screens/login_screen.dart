import 'package:bbnews/screens/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:bbnews/screens/registration_screen.dart';

class LoginWindow extends StatefulWidget {
  @override
  State<LoginWindow> createState() => _LoginWindowState();
}

class _LoginWindowState extends State<LoginWindow> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 230,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Image.asset(
            "assets/images/bbnews.jpg",
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
              color: Colors.blue,
              size: 35,
            ),
            onTap: () {
              print('Search Clicked');
            },
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            child: const Icon(
              Icons.notifications,
              color: Colors.blue,
              size: 35,
            ),
            onTap: () {
              print('Notification clicked');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context); // Navigate back when the arrow is tapped
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Text(
                'Login',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: fontSize,
                    color: Colors.blue,
                    letterSpacing: 0.7),
              ),
              Divider(
                height: screenWidth * 0.04,
                thickness: 3,
                indent: 0,
                endIndent: screenWidth * 0.77,
                color: Colors.lightBlueAccent,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('We were eagerly waiting for you'),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.mail_outline_outlined),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.key),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, you can proceed with login.
                  }
                },
                style: TextButton.styleFrom(
                  elevation: 3,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(letterSpacing: 1, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(letterSpacing: 0.5, fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(letterSpacing: 0.5, fontSize: fontSize),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterWindow(),
                        ),
                      );
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(letterSpacing: 0.5, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
