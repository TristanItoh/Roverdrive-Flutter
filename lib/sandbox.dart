import 'package:flutter/material.dart';
import 'app_colors.dart';

class Sandbox extends StatefulWidget {
  const Sandbox({super.key});

  @override
  State<Sandbox> createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  List<String> _commandQueue = [];

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
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryColo,
      body: Stack(
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

          Positioned(
            top: 48,
            left: 28,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grayColor, width: 3),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),

          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Sandbox',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.15,
            right: screenWidth * 0.35,
            bottom: screenHeight * 0.15,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColo,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.grayColor, width: 6),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.grayColor,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Command Queue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_commandQueue.isNotEmpty)
                          GestureDetector(
                            onTap: _clearQueue,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7A1A25),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.grayColor,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: _commandQueue.isEmpty
                        ? Center(
                            child: Text(
                              'No commands yet\nAdd commands using buttons =>',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 22,
                                height: 1.5,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _commandQueue.length,
                            itemBuilder: (context, index) {
                              final command = _commandQueue[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7A1A25),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.grayColor,
                                    width: 3,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryColo,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.grayColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    Icon(
                                      _getCommandIcon(command),
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Text(
                                        command,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () => _removeCommand(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColo,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.grayColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
