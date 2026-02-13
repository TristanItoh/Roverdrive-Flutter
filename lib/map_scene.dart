import 'dart:math';

import 'package:flutter/material.dart' hide Material;
import 'package:flutter/scheduler.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

class MapScene extends StatefulWidget {
  const MapScene({super.key});

  @override
  State<MapScene> createState() => _MapSceneState();
}

class _MapSceneState extends State<MapScene>
    with SingleTickerProviderStateMixin {
  double _elapsed = 0;
  Scene? _scene;
  Node? _carNode;
  late final Ticker _ticker;

  static const int gridSize = 11;
  static const double spacing = 1;
  static const double carHeight = 0.5;
  static const double carScale = 1.4;
  static const int minCarGridCoord = -4;
  static const int maxCarGridCoord = 4;

  // Edit these in code to move the car on the 10x10 grid.
  // x = sideways, y = forward/back.
  int _carGridX = 0;
  int _carGridY = 0;

  static const List<String> texturePaths = ['assets/textures/grass.png'];

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
      final List<gpu.Texture> textures = await Future.wait(
        texturePaths.map((path) => gpuTextureFromAsset(path)),
      );

      for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
          final node = await Node.fromAsset('assets/models/cube8.model');
          node.name = 'cube_${row}_$col';

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

      final carNode = await Node.fromAsset('assets/models/car.model');
      carNode.name = 'car';
      _makeNodeDoubleSided(carNode);
      _carNode = carNode;
      _updateCarTransform();
      scene.add(carNode);
    } catch (e) {
      debugPrint('Failed to init scene: $e');
    }

    setState(() {
      _scene = scene;
    });
  }

  void _updateCarTransform() {
    if (_carNode == null) {
      return;
    }

    final int clampedX = _carGridX.clamp(minCarGridCoord, maxCarGridCoord);
    final int clampedY = _carGridY.clamp(minCarGridCoord, maxCarGridCoord);

    _carNode!.localTransform = vm.Matrix4.compose(
      vm.Vector3(clampedX.toDouble(), carHeight, clampedY.toDouble()),
      vm.Quaternion.identity(),
      vm.Vector3.all(carScale),
    );
  }

  void _makeNodeDoubleSided(Node node) {
    if (node.mesh != null) {
      for (final primitive in node.mesh!.primitives) {
        primitive.material = DoubleSidedMaterial(primitive.material);
      }
    }
    for (final child in node.children) {
      _makeNodeDoubleSided(child);
    }
  }

  void applyTexture(Node node, gpu.Texture texture) {
    if (node.mesh != null) {
      for (final primitive in node.mesh!.primitives) {
        final mat = UnlitMaterial();
        mat.baseColorTexture = texture;
        mat.baseColorFactor = vm.Vector4(1, 1, 1, 1);
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
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '10x10 Grid  |  car pos in code: (_carGridX, _carGridY)',
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

class DoubleSidedMaterial extends Material {
  DoubleSidedMaterial(this._base) {
    setFragmentShader(_base.fragmentShader);
  }

  final Material _base;

  @override
  void bind(
    gpu.RenderPass pass,
    gpu.HostBuffer transientsBuffer,
    Environment environment,
  ) {
    _base.bind(pass, transientsBuffer, environment);
    pass.setCullMode(gpu.CullMode.none);
  }

  @override
  bool isOpaque() => _base.isOpaque();
}
