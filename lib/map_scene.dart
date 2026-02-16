import 'dart:math';

import 'package:flutter/material.dart' hide Material;
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

class MapScene extends StatefulWidget {
  final List<String> commands;

  const MapScene({super.key, this.commands = const []});

  @override
  State<MapScene> createState() => _MapSceneState();
}

class _MapSceneState extends State<MapScene>
    with SingleTickerProviderStateMixin {
  Scene? _scene;
  Node? _carNode;
  late final AnimationController _commandAnimationController;

  int _carGridX = 0;
  int _carGridY = 0;
  int _carRotation = 0;
  double _carVisualX = 0;
  double _carVisualY = 0;
  double _carVisualRotation = 0;
  bool _isExecuting = false;
  bool _isCountingDown = false;
  bool _executionCompleted = false;
  int _countdownValue = 0;
  int _currentCommandIndex = 0;

  static const int gridSize = 11;
  static const double spacing = 1;
  static const double carHeight = 0.5;
  static const double carScale = 1.4;
  static const int minCarGridCoord = -4;
  static const int maxCarGridCoord = 4;
  static const double cameraHeight = 7;
  static const double cameraDistance = 5;
  static const bool followCarCamera = true;
  static const Duration moveTweenDuration = Duration(milliseconds: 700);
  static const Duration turnTweenDuration = Duration(milliseconds: 1400);
  static const Duration commandPauseDuration = Duration(milliseconds: 150);

  static const List<String> texturePaths = ['assets/textures/grass.png'];

  @override
  void initState() {
    super.initState();
    _commandAnimationController = AnimationController(vsync: this);

    debugPrint('Received ${widget.commands.length} command(s)');
    for (int i = 0; i < widget.commands.length; i++) {
      debugPrint('Command ${i + 1}: ${widget.commands[i]}');
    }

    _initScene();
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
      _syncVisualToLogical();
      _updateCarTransform();
      scene.add(carNode);
    } catch (e) {
      debugPrint('Failed to init scene: $e');
    }

    setState(() {
      _scene = scene;
    });

    if (widget.commands.isNotEmpty) {
      _startExecutionWithCountdown();
    }
  }

  Future<void> _startExecutionWithCountdown() async {
    if (_isExecuting || _isCountingDown || widget.commands.isEmpty) return;

    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() {
        _isCountingDown = true;
        _countdownValue = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;
    setState(() {
      _isCountingDown = false;
      _countdownValue = 0;
    });

    await _executeCommands();
  }

  void _updateCarTransform() {
    if (_carNode == null) {
      return;
    }

    _carNode!.localTransform = vm.Matrix4.compose(
      vm.Vector3(_carVisualX, carHeight, _carVisualY),
      vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), _carVisualRotation),
      vm.Vector3.all(carScale),
    );
  }

  Future<void> _executeCommands() async {
    if (_isExecuting || _isCountingDown || widget.commands.isEmpty) return;

    setState(() {
      _isExecuting = true;
      _executionCompleted = false;
      _currentCommandIndex = 0;
    });

    for (int i = 0; i < widget.commands.length; i++) {
      setState(() {
        _currentCommandIndex = i;
      });

      final command = widget.commands[i];
      debugPrint('Executing command ${i + 1}: $command');

      switch (command) {
        case 'Forward':
          await _moveForward();
          break;
        case 'Backward':
          await _moveBackward();
          break;
        case 'Turn Left':
          await _turnLeft();
          break;
        case 'Turn Right':
          await _turnRight();
          break;
      }

      await Future.delayed(commandPauseDuration);
    }

    setState(() {
      _isExecuting = false;
      _executionCompleted = true;
    });
  }

  Future<void> _moveForward() async {
    switch (_carRotation) {
      case 0:
        await _moveBy(0, 1);
        break;
      case 1:
        await _moveBy(1, 0);
        break;
      case 2:
        await _moveBy(0, -1);
        break;
      case 3:
        await _moveBy(-1, 0);
        break;
    }
  }

  Future<void> _moveBackward() async {
    switch (_carRotation) {
      case 0:
        await _moveBy(0, -1);
        break;
      case 1:
        await _moveBy(-1, 0);
        break;
      case 2:
        await _moveBy(0, 1);
        break;
      case 3:
        await _moveBy(1, 0);
        break;
    }
  }

  Future<void> _turnLeft() async {
    _carRotation = (_carRotation - 1) % 4;
    if (_carRotation < 0) {
      _carRotation = 3;
    }

    final double startRotation = _carVisualRotation;
    final double endRotation = startRotation - (pi / 2);
    await _runCommandTween(
      duration: turnTweenDuration,
      onTick: (t) {
        setState(() {
          _carVisualRotation = _lerp(startRotation, endRotation, t);
          _updateCarTransform();
        });
      },
    );
  }

  Future<void> _turnRight() async {
    _carRotation = (_carRotation + 1) % 4;

    final double startRotation = _carVisualRotation;
    final double endRotation = startRotation + (pi / 2);
    await _runCommandTween(
      duration: turnTweenDuration,
      onTick: (t) {
        setState(() {
          _carVisualRotation = _lerp(startRotation, endRotation, t);
          _updateCarTransform();
        });
      },
    );
  }

  Future<void> _moveBy(int dx, int dy) async {
    final int nextX = (_carGridX + dx).clamp(minCarGridCoord, maxCarGridCoord);
    final int nextY = (_carGridY + dy).clamp(minCarGridCoord, maxCarGridCoord);

    final double startX = _carVisualX;
    final double startY = _carVisualY;

    _carGridX = nextX;
    _carGridY = nextY;

    final double endX = _carGridX.toDouble();
    final double endY = _carGridY.toDouble();

    await _runCommandTween(
      duration: moveTweenDuration,
      onTick: (t) {
        setState(() {
          _carVisualX = _lerp(startX, endX, t);
          _carVisualY = _lerp(startY, endY, t);
          _updateCarTransform();
        });
      },
    );
  }

  Future<void> _runCommandTween({
    required Duration duration,
    required void Function(double t) onTick,
  }) async {
    _commandAnimationController
      ..stop()
      ..duration = duration;

    void listener() {
      final double t = Curves.easeInOut.transform(
        _commandAnimationController.value,
      );
      onTick(t);
    }

    _commandAnimationController.addListener(listener);
    await _commandAnimationController.forward(from: 0);
    _commandAnimationController.removeListener(listener);
  }

  void _syncVisualToLogical() {
    _carVisualX = _carGridX.toDouble();
    _carVisualY = _carGridY.toDouble();
    _carVisualRotation = _carRotation * pi / 2;
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
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
    _commandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm.Vector3 cameraPosition = followCarCamera
        ? vm.Vector3(
            _carVisualX - sin(_carVisualRotation) * cameraDistance,
            cameraHeight,
            _carVisualY - cos(_carVisualRotation) * cameraDistance,
          )
        : vm.Vector3(0, 12, -14);

    final vm.Vector3 cameraTarget = followCarCamera
        ? vm.Vector3(_carVisualX, carHeight, _carVisualY)
        : vm.Vector3(0, 0, 0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 38, 129, 182),
              Color.fromARGB(255, 35, 107, 148),
            ],
          ),
        ),
        child: Stack(
          children: [
            if (_scene != null)
              SizedBox.expand(
                child: CustomPaint(
                  painter: ScenePainter(
                    scene: _scene!,
                    camera: PerspectiveCamera(
                      position: cameraPosition,
                      target: cameraTarget,
                    ),
                  ),
                ),
              ),
            if (_isCountingDown)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$_countdownValue',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_executionCompleted)
              Positioned.fill(
                child: SafeArea(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.greenAccent.withValues(alpha: 0.75),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Done Executing Commands',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Return'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.12,
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
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
