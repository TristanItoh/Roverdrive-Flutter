import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'map_scene.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  final List<String> _commandQueue = [];
  final ScrollController _queueScrollController = ScrollController();

  void _addCommand(String command) {
    setState(() {
      _commandQueue.add(command);
    });
  }

  void _removeCommand(int index) {
    setState(() {
      _commandQueue.removeAt(index);
    });
  }

  void _clearQueue() {
    setState(() {
      _commandQueue.clear();
    });
  }

  IconData _getCommandIcon(String command) {
    switch (command) {
      case 'Forward':
        return Icons.arrow_upward;
      case 'Backward':
        return Icons.arrow_downward;
      case 'Turn Left':
        return Icons.arrow_back;
      case 'Turn Right':
        return Icons.arrow_forward;
      default:
        return Icons.help;
    }
  }

  @override
  void dispose() {
    _queueScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryColo,
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 780;
                      final queuePane = _buildQueuePane(
                        screenWidth,
                        stacked: stacked,
                      );

                      if (stacked) {
                        return Column(
                          children: [
                            Expanded(flex: 7, child: queuePane),
                            const SizedBox(height: 12),
                            Expanded(flex: 3, child: _buildBottomControlsBar()),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 5, child: queuePane),
                          const SizedBox(width: 18),
                          Expanded(flex: 2, child: _buildControlsPane()),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQueuePane(double screenWidth, {required bool stacked}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 520;
                final actions = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_commandQueue.isNotEmpty)
                      _actionButton(
                        label: 'Clear All',
                        onTap: _clearQueue,
                        icon: Icons.clear_all,
                      ),
                    _actionButton(
                      label: 'Execute (${_commandQueue.length})',
                      icon: Icons.play_arrow,
                      enabled: _commandQueue.isNotEmpty,
                      onTap: () {
                        final parentContext = context;
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: AppColors.secondaryColo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: AppColors.grayColor,
                                width: 4,
                              ),
                            ),
                            title: const Text(
                              'Execute Commands',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(
                              'Ready to execute ${_commandQueue.length} command(s)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  Navigator.push(
                                    parentContext,
                                    MaterialPageRoute(
                                      builder: (_) => MapScene(
                                        commands: List<String>.from(
                                          _commandQueue,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Execute',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildHeaderBackButton(),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Command Queue',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(alignment: Alignment.centerRight, child: actions),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderBackButton(),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Command Queue',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          actions,
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              thickness: 2,
              color: AppColors.grayColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: _commandQueue.isEmpty
                  ? Center(
                      child: Text(
                        stacked
                            ? 'No commands yet. Tap controls below.'
                            : (screenWidth < 900
                                  ? 'No commands yet. Use controls below.'
                                  : 'No commands yet\nAdd commands using controls on the right.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 22,
                          height: 1.4,
                        ),
                      ),
                    )
                  : stacked
                  ? Scrollbar(
                      controller: _queueScrollController,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(6),
                      child: ListView.separated(
                        controller: _queueScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: _commandQueue.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: _buildQueueCard(
                              index,
                              _commandQueue[index],
                              horizontal: true,
                            ),
                          );
                        },
                      ),
                    )
                  : Scrollbar(
                      controller: _queueScrollController,
                      thumbVisibility: true,
                      thickness: 6,
                      radius: const Radius.circular(6),
                      child: ListView.builder(
                        controller: _queueScrollController,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(right: 8),
                        itemCount: _commandQueue.length,
                        itemBuilder: (context, index) {
                          return _buildQueueCard(index, _commandQueue[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.secondaryColo.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grayColor, width: 2),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildQueueCard(int index, String command, {bool horizontal = false}) {
    final card = Container(
      margin: EdgeInsets.only(bottom: horizontal ? 0 : 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF7A1A25).withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(_getCommandIcon(command), color: Colors.white, size: 19),
          const SizedBox(width: 8),
          if (horizontal)
            Text(
              command,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Expanded(
              child: Text(
                command,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _removeCommand(index),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );

    if (horizontal) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: SizedBox(height: 76, child: card),
      );
    }

    return card;
  }

  Widget _buildControlsPane() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grayColor.withValues(alpha: 0.18),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          children: [
            const Text(
              'Controls',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 2,
              color: AppColors.grayColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _buildControlButton(
                      label: 'Forward',
                      icon: Icons.arrow_upward,
                      onTap: () => _addCommand('Forward'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildControlButton(
                      label: 'Backward',
                      icon: Icons.arrow_downward,
                      onTap: () => _addCommand('Backward'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildControlButton(
                      label: 'Turn Left',
                      icon: Icons.arrow_back,
                      onTap: () => _addCommand('Turn Left'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildControlButton(
                      label: 'Turn Right',
                      icon: Icons.arrow_forward,
                      onTap: () => _addCommand('Turn Right'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControlsBar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildBottomControlButton(
                label: 'Forward',
                icon: Icons.arrow_upward,
                onTap: () => _addCommand('Forward'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildBottomControlButton(
                label: 'Back',
                icon: Icons.arrow_downward,
                onTap: () => _addCommand('Backward'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildBottomControlButton(
                label: 'Turn Left',
                icon: Icons.arrow_back,
                onTap: () => _addCommand('Turn Left'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildBottomControlButton(
                label: 'Turn Right',
                icon: Icons.arrow_forward,
                onTap: () => _addCommand('Turn Right'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControlButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF7A1A25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF7A1A25) : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grayColor, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF7A1A25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayColor, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
