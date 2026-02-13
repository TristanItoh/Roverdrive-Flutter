import 'package:flutter/material.dart';
import 'global_storage.dart';

class Settings extends StatefulWidget {
  final double buttonTop;
  final double buttonRight;

  const Settings({
    Key? key,
    this.buttonTop = 4,
    this.buttonRight = 4,
  }) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showSettings = false;

  void resetData() {
    // Call the reset function from GlobalStorage
    //GlobalStorage().resetState();
    
    // Close the modal
    setState(() {
      showSettings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Settings Button
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
                color: const Color(0xFF878787),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF3c3c3c),
                  width: 6,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/settingsIcon.png',
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
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF878787),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF3c3c3c),
                      width: 8,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Back button
                      Positioned(
                        bottom: -24,
                        left: -20,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Settings title
                          const Text(
                            'Settings',
                            style: TextStyle(
                              color: Color(0xFFF0F0F0),
                              fontFamily: 'SpaceMono',
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 80),

                          // Reset Data button
                          GestureDetector(
                            onTap: resetData,
                            child: Container(
                              width: 240,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2a2a2a),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 6,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'RESET DATA',
                                  style: TextStyle(
                                    color: Color(0xFFF0F0F0),
                                    fontFamily: 'SpaceMono',
                                    fontSize: 30,
                                    height: 2.33,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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