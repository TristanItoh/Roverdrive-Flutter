import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'guide.dart';
import 'profile.dart';
import 'settings.dart';
import 'drive_button.dart';
import 'global_storage.dart';
import 'sandbox.dart';
import 'story.dart';

class MainScene extends StatefulWidget {
  const MainScene({super.key});

  @override
  State<MainScene> createState() => _HomeState();
}

class _HomeState extends State<MainScene> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )..repeat();

    _spinController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    _spinAnimation = Tween<double>(
      begin: 0,
      end: 6.283185307179586,
    ).animate(_spinController);

    _videoController =
        VideoPlayerController.asset('assets/videos/roverAnim.mp4')
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _spinController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a), // Adjust to your bColorre
      body: Stack(
        children: [
          // Animated background grid
          Positioned.fill(
            child: ClipRect(
              child: AnimatedBuilder(
                animation: _slideController,
                builder: (context, child) {
                  final double translateX =
                      -_slideController.value * (screenWidth * 2 / 8);
                  final double translateY =
                      ((1 - _slideController.value) * (-screenWidth * 2 / 8));

                  return Transform.translate(
                    offset: Offset(translateX, translateY),
                    child: Center(
                      child: Image.asset(
                        'assets/images/grid.png',
                        width: screenWidth * 10,
                        height: screenWidth * 10,
                        fit: BoxFit.contain,
                        opacity: const AlwaysStoppedAnimation(0.6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: screenHeight * 0.35,
                  child: Container(
                    width: screenWidth * 0.96,
                    height: screenHeight * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey, width: 8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        if (_videoController.value.isInitialized)
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.7 * 0.95,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController.value.size.width,
                                height: _videoController.value.size.height,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),

                        Positioned(
                          top: screenHeight * 0.07,
                          right: 32,
                          child: GestureDetector(
                            onTap: () {
                              GlobalStorage().updateInSandbox(true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Sandbox(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2a2a2a),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 6,
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/sandboxIcon.png',
                                    width: 144,
                                    height: 144,
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    bottom: -290,
                                    child: Transform.scale(
                                      scale: 0.25,
                                      child: Image.asset(
                                        'assets/images/sandboxtext.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: screenHeight * 0.07,
                          left: 32,
                          child: GestureDetector(
                            onTap: () {
                              GlobalStorage().updateInSandbox(false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Story(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2a2a2a),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 6,
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/mapIcon.png',
                                    width: 144,
                                    height: 144,
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    bottom: -290,
                                    child: Transform.scale(
                                      scale: 0.25,
                                      child: Image.asset(
                                        'assets/images/campaigntext.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.038,
                  child: Container(
                    width: screenWidth * 0.51,
                    height: screenHeight * 0.35,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 8),
                    ),
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.1,
                  left: screenWidth * 0.2609,
                  child: Container(
                    width: screenWidth * 0.015,
                    height: screenHeight * 0.2,
                    color: const Color(0xFF2a2a2a),
                  ),
                ),

                Positioned(
                  top: -screenHeight * 0.05,
                  child: Image.asset(
                    'assets/images/rdBottom.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.09,
                  left: screenWidth * 0.27,
                  child: AnimatedBuilder(
                    animation: _spinAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinAnimation.value,
                        child: Image.asset(
                          'assets/images/gear.png',
                          width: screenWidth * 0.07,
                          height: screenWidth * 0.07,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: -screenHeight * 0.05,
                  child: Image.asset(
                    'assets/images/rdTop.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          const Settings(buttonRight: 28, buttonTop: 48),
          const Guide(buttonRight: 105, buttonTop: 48),
          const DriveButton(buttonRight: 110, buttonTop: 48),
          const Profile(buttonRight: 710, buttonTop: 48),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              '${(GlobalStorage().levelsCompleted / 24 * 100).toStringAsFixed(1)}% Completed',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF0F0F0),
                fontFamily: 'SpaceMono',
                fontSize: 30,
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
