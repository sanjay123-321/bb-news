import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
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
                height: screenHeight * 0.2,
              ),
              Text(
                'Forgot Password',
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
                endIndent: screenWidth * 0.7,
                color: Colors.lightBlueAccent,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Let me Help You With Your Password'),
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
                height: 20,
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
                      'Send Mail',
                      style: TextStyle(letterSpacing: 1, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
