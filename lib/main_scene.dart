import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

import 'guide.dart';
import 'profile.dart';
import 'settings.dart';
import 'drive_button.dart';
import 'global_storage.dart';
import 'sandbox.dart';
import 'story.dart';
import 'app_colors.dart';

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
  int _lastGlitchBurstId = -1;
  List<_GlitchSlice> _glitchSlices = const [];

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

  void _generateGlitchSlices(int burstId) {
    final rng = math.Random(burstId);
    final count = 1 + rng.nextInt(4);
    _glitchSlices = List.generate(count, (_) {
      return _GlitchSlice(
        topFraction: 0.12 + (rng.nextDouble() * 0.6),
        heightFraction: 0.018 + (rng.nextDouble() * 0.03),
        opacity: 0.55 + (rng.nextDouble() * 0.3),
        maxOffset: 16 + (rng.nextDouble() * 28),
        speed: 120 + (rng.nextDouble() * 110),
        phase: rng.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryColo,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _slideController,
              builder: (context, child) {
                final t = _slideController.value;
                final wave = math.sin(t * 2 * math.pi);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.secondaryColo,
                            const Color(0xFF7A1A25),
                            const Color(0xFF500D16),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.18 + (wave * 0.01)),
                      child: Container(
                        width: screenWidth * 0.84,
                        height: screenHeight * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: const RadialGradient(
                            center: Alignment(0, -0.1),
                            radius: 1.0,
                            colors: [
                              Color.fromRGBO(255, 182, 182, 0.14),
                              Color.fromRGBO(255, 182, 182, 0.035),
                              Color.fromRGBO(255, 182, 182, 0.0),
                            ],
                            stops: [0.0, 0.62, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _AmbientBackdropPainter(progress: t),
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, -0.35),
                          radius: 1.08,
                          colors: [
                            Color.fromRGBO(255, 255, 255, 0.08),
                            Color.fromRGBO(0, 0, 0, 0.36),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: screenHeight * 0.36,
                  child: Container(
                    width: screenWidth * 0.72,
                    height: screenHeight * 0.61,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2A2D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF111114),
                        width: 5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.45),
                          blurRadius: 18,
                          spreadRadius: 3,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRect(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(255, 255, 255, 0.24),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (_videoController.value.isInitialized)
                                AnimatedBuilder(
                                  animation: _slideController,
                                  builder: (context, child) {
                                    final t = _slideController.value;
                                    final elapsedSeconds =
                                        (_slideController
                                                .lastElapsedDuration
                                                ?.inMilliseconds ??
                                            0) /
                                        1000.0;
                                    final glitchTimeline =
                                        elapsedSeconds * 0.52;
                                    final glitchCycle = glitchTimeline % 1.0;
                                    final burstId = glitchTimeline.floor();
                                    final isGlitchBurst = glitchCycle > 0.9;
                                    if (isGlitchBurst &&
                                        burstId != _lastGlitchBurstId) {
                                      _lastGlitchBurstId = burstId;
                                      _generateGlitchSlices(burstId);
                                    }
                                    final burstStrength = isGlitchBurst
                                        ? ((glitchCycle - 0.9) / 0.1).clamp(
                                            0.0,
                                            1.0,
                                          )
                                        : 0.0;
                                    final wave = math.sin(
                                      t * 2 * math.pi * 120,
                                    );
                                    final frameJumpX = isGlitchBurst
                                        ? wave * 7 * burstStrength
                                        : 0.0;

                                    Widget videoFrame() {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: screenHeight,
                                        child: Transform.translate(
                                          offset: const Offset(-72, 8),
                                          child: Transform.scale(
                                            scale: 2.2,
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: _videoController
                                                    .value
                                                    .size
                                                    .width,
                                                height: _videoController
                                                    .value
                                                    .size
                                                    .height,
                                                child: VideoPlayer(
                                                  _videoController,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return Stack(
                                      children: [
                                        Transform.translate(
                                          offset: Offset(frameJumpX, 0),
                                          child: videoFrame(),
                                        ),
                                        if (isGlitchBurst)
                                          ..._glitchSlices.map((slice) {
                                            final stripJumpX =
                                                math.sin(
                                                  (t *
                                                          2 *
                                                          math.pi *
                                                          slice.speed) +
                                                      slice.phase,
                                                ) *
                                                slice.maxOffset *
                                                burstStrength;
                                            return Positioned(
                                              left: 0,
                                              right: 0,
                                              top:
                                                  screenHeight *
                                                  slice.topFraction,
                                              height:
                                                  screenHeight *
                                                  slice.heightFraction,
                                              child: ClipRect(
                                                child: Opacity(
                                                  opacity: slice.opacity,
                                                  child: Transform.translate(
                                                    offset: Offset(
                                                      stripJumpX,
                                                      0,
                                                    ),
                                                    child: videoFrame(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        Positioned.fill(
                                          child: IgnorePointer(
                                            child: Transform.translate(
                                              offset: Offset(frameJumpX, 0),
                                              child: CustomPaint(
                                                painter: _TvScanlinePainter(
                                                  progress: t,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              Positioned(
                                top: 14,
                                right: 14,
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
                                      color: AppColors.secondaryColo,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.grayColor,
                                        width: 5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/sandboxIcon.png',
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Sandbox',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
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
                    ),
                  ),
                ),

                // Positioned(
                //   top: screenHeight * 0.07,
                //   left: 32,
                //   child: GestureDetector(
                //     onTap: () {
                //       GlobalStorage().updateInSandbox(false);
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const Story(),
                //         ),
                //       );
                //     },
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: AppColors.secondaryColo,
                //         borderRadius: BorderRadius.circular(12),
                //         border: Border.all(
                //           color: AppColors.grayColor,
                //           width: 6,
                //         ),
                //       ),
                //       padding: const EdgeInsets.only(bottom: 40),
                //       child: Stack(
                //         alignment: Alignment.center,
                //         children: [
                //           Image.asset(
                //             'assets/images/mapIcon.png',
                //             width: 144,
                //             height: 144,
                //             fit: BoxFit.contain,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Logo stays in original positions below. Removed the old
                // framing container so it sits directly on the scene.
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
                  top: screenHeight * 0.082,
                  left: screenWidth * 0.263,
                  child: AnimatedBuilder(
                    animation: _spinAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _spinAnimation.value,
                        child: Image.asset(
                          'assets/images/gear.png',
                          width: screenWidth * 0.085,
                          height: screenWidth * 0.085,
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

          //const Settings(buttonRight: 28, buttonTop: 48),
          //const Guide(buttonRight: 105, buttonTop: 48),
          //const DriveButton(buttonRight: 110, buttonTop: 48),
          //const Profile(buttonRight: 710, buttonTop: 48),

          // Positioned(
          //   bottom: 10,
          //   left: 0,
          //   right: 0,
          //   child: Text(
          //     '${(GlobalStorage().levelsCompleted / 24 * 100).toStringAsFixed(1)}% Completed',
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(
          //       color: Color(0xFFF0F0F0),
          //       fontFamily: 'SpaceMono',
          //       fontSize: 30,
          //       height: 1.33,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _TvScanlinePainter extends CustomPainter {
  final double progress;

  _TvScanlinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final pulse = math
        .pow(math.max(0.0, math.sin(progress * 2 * math.pi * 4.0)), 22)
        .toDouble();
    final flicker =
        (math.sin(progress * 410) * 0.008) + (math.sin(progress * 833) * 0.006);

    if (flicker > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = Color.fromRGBO(255, 255, 255, flicker + (pulse * 0.045)),
      );
    } else {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Color.fromRGBO(0, 0, 0, (-flicker) * 0.45),
      );
    }

    final scanlinePaint = Paint()
      ..color = Color.fromRGBO(
        0,
        0,
        0,
        0.26 + (math.sin(progress * 25) * 0.03),
      );
    const scanlineStep = 5.0;
    for (double y = 0; y < size.height; y += scanlineStep) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), scanlinePaint);
    }

    final barCenter = (progress * size.height * 1.2) - (size.height * 0.1);
    final barHeight = size.height * 0.22;
    final barRect = Rect.fromLTWH(
      0,
      barCenter - (barHeight / 2),
      size.width,
      barHeight,
    );
    final barPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.0),
          Color.fromRGBO(255, 255, 255, 0.20),
          Color.fromRGBO(255, 255, 255, 0.0),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(barRect);
    canvas.drawRect(barRect, barPaint);

    final fastBarCenter =
        ((progress * 2.4 + 0.33) % 1.0) * size.height - (size.height * 0.08);
    final fastBarHeight = size.height * 0.1;
    final fastBarRect = Rect.fromLTWH(
      0,
      fastBarCenter - (fastBarHeight / 2),
      size.width,
      fastBarHeight,
    );
    final fastBarPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.0),
          Color.fromRGBO(255, 255, 255, 0.12),
          Color.fromRGBO(255, 255, 255, 0.0),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(fastBarRect);
    canvas.drawRect(fastBarRect, fastBarPaint);

    for (int i = 0; i < 3; i++) {
      final bandY =
          ((progress * (1.3 + i * 0.33) + (i * 0.21)) % 1.0) * size.height;
      final bandHeight = 10.0 + (i * 6.0);
      final bandRect = Rect.fromLTWH(0, bandY, size.width, bandHeight);
      final bandAlpha =
          0.03 + (0.018 * math.sin((progress * 2 * math.pi * 4) + i));
      canvas.drawRect(
        bandRect,
        Paint()..color = Color.fromRGBO(255, 255, 255, bandAlpha.abs()),
      );
    }

    final vignette = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [Color.fromRGBO(0, 0, 0, 0.0), Color.fromRGBO(0, 0, 0, 0.18)],
        stops: [0.65, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant _TvScanlinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _AmbientBackdropPainter extends CustomPainter {
  final double progress;

  _AmbientBackdropPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color.fromRGBO(255, 206, 196, 0.09)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final double phase = progress * 2 * math.pi;
    const int lines = 14;
    for (int i = 0; i < lines; i++) {
      final yBase = (size.height * 0.14) + (i * size.height * 0.055);
      final path = Path();
      for (double x = 0; x <= size.width; x += 12) {
        final y =
            yBase +
            math.sin((x / size.width * 2.6 * math.pi) + phase + (i * 0.55)) *
                7 +
            math.cos(
                  (x / size.width * 1.4 * math.pi) - (phase * 0.8) + (i * 0.3),
                ) *
                4;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _GlitchSlice {
  final double topFraction;
  final double heightFraction;
  final double opacity;
  final double maxOffset;
  final double speed;
  final double phase;

  const _GlitchSlice({
    required this.topFraction,
    required this.heightFraction,
    required this.opacity,
    required this.maxOffset,
    required this.speed,
    required this.phase,
  });
}
