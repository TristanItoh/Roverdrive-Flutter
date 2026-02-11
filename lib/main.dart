import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scene/scene.dart';
import 'package:flutter_scene/src/asset_helpers.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:flutter_gpu/gpu.dart' as gpu;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  double _elapsed = 0;
  Scene? _scene;
  late final Ticker _ticker;

  static const int gridSize = 10;
  static const double spacing = 1;

  // List your texture asset paths here — add as many as you want
  static const List<String> texturePaths = [
    'assets/textures/grass.png',
  ];

  @override
  void initState() {
    super.initState();
    _initScene();

    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed.inMilliseconds.toDouble() / 1000.0;
      });
    });
    _ticker.start();
  }

  Future<void> _initScene() async {
    await Scene.initializeStaticResources();

    final scene = Scene();

    try {
      // Load all textures once upfront
      final List<gpu.Texture> textures = await Future.wait(
        texturePaths.map((path) => gpuTextureFromAsset(path)),
      );

      for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
          final node = await Node.fromAsset('assets/models/cube8.model');
          node.name = 'cube_${row}_$col';

          // Pick a texture — cycle through them, or use any logic you want
          final texture = textures[(row * gridSize + col) % textures.length];
          applyTexture(node, texture);

          final double x = (col - gridSize / 2.0 + 0.5) * spacing;
          final double z = (row - gridSize / 2.0 + 0.5) * spacing;

          node.localTransform = vm.Matrix4.compose(
            vm.Vector3(x, 0, z),
            vm.Quaternion.identity(),
            vm.Vector3.all(1.0),
          );

          scene.add(node);
        }
      }
    } catch (e) {
      debugPrint('Failed to init scene: $e');
    }

    setState(() {
      _scene = scene;
    });
  }

  /// Recursively applies a gpu.Texture to all primitives on a node tree
  void applyTexture(Node node, gpu.Texture texture) {
    if (node.mesh != null) {
      for (final primitive in node.mesh!.primitives) {
        final mat = UnlitMaterial();
        mat.baseColorTexture = texture;
        mat.baseColorFactor = vm.Vector4(1, 1, 1, 1); // white = show texture as-is
        primitive.material = mat;
      }
    }
    for (final child in node.children) {
      applyTexture(child, texture);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_scene != null)
            SizedBox.expand(
              child: CustomPaint(
                painter: ScenePainter(
                  scene: _scene!,
                  camera: PerspectiveCamera(
                    position: vm.Vector3(
                      sin(_elapsed * 0.2) * 20,
                      15,
                      cos(_elapsed * 0.2) * 20,
                    ),
                    target: vm.Vector3(0, 0, 0),
                  ),
                ),
              ),
            ),

          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '10×10 Grid',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScenePainter extends CustomPainter {
  ScenePainter({required this.scene, required this.camera});

  final Scene scene;
  final Camera camera;

  @override
  void paint(Canvas canvas, Size size) {
    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(ScenePainter oldDelegate) => true;
}