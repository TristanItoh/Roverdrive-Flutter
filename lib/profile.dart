import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final double buttonTop;
  final double buttonRight;

  const Profile({
    Key? key,
    this.buttonTop = 4,
    this.buttonRight = 4,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showSettings = false;
  String email = '';
  String password = '';
  String? currentUser;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }

    // Simulate sign in
    setState(() {
      currentUser = email;
    });

    // Load user data from local storage or state management
    // GlobalStorage().loadUserData();
  }

  void signUp() {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }

    // Simulate sign up
    setState(() {
      currentUser = email;
    });

    // Create default user data
    // GlobalStorage().createDefaultData();
  }

  void signOut() {
    setState(() {
      currentUser = null;
      email = '';
      password = '';
      emailController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Profile Button
        Positioned(
          top: widget.buttonTop,
          left: widget.buttonRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                showSettings = true;
              });
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                  width: 6,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/profile.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // Settings Modal
        if (showSettings)
          Stack(
            children: [
              // Black overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showSettings = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),

              // Modal content
              Center(
                child: Container(
                  width: 400,
                  height: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.grey,
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Close button
                      Positioned(
                        top: 4,
                        left: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showSettings = false;
                            });
                          },
                          child: Image.asset(
                            'assets/images/home.png',
                            width: 40,
                            height: 40,
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            currentUser != null
                                ? 'Signed In as $currentUser'
                                : 'Sign In',
                            style: const TextStyle(
                              color: Color(0xFFF0F0F0),
                              fontFamily: 'SpaceMono',
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Sign in/up form
                          if (currentUser == null) ...[
                            // Email input
                            SizedBox(
                              width: 320,
                              child: TextField(
                                controller: emailController,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFC8C8C8),
                                    fontFamily: 'SpaceMono',
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF2a2a2a),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'SpaceMono',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password input
                            SizedBox(
                              width: 320,
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFC8C8C8),
                                    fontFamily: 'SpaceMono',
                                    fontSize: 16,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF2a2a2a),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'SpaceMono',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Buttons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Log In button
                                GestureDetector(
                                  onTap: signIn,
                                  child: Container(
                                    width: 160,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2a2a2a),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 6,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Log In',
                                      style: TextStyle(
                                        color: Color(0xFFF0F0F0),
                                        fontFamily: 'SpaceMono',
                                        fontSize: 30,
                                        height: 1.83,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Sign Up button
                                GestureDetector(
                                  onTap: signUp,
                                  child: Container(
                                    width: 160,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2a2a2a),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 6,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xFFF0F0F0),
                                        fontFamily: 'SpaceMono',
                                        fontSize: 30,
                                        height: 1.83,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Sign out button (when signed in)
                          if (currentUser != null)
                            GestureDetector(
                              onTap: signOut,
                              child: Container(
                                width: 220,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2a2a2a),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 6,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Color(0xFFF0F0F0),
                                    fontFamily: 'SpaceMono',
                                    fontSize: 30,
                                    height: 1.83,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}