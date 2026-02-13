import 'package:flutter/material.dart';

class Guide extends StatefulWidget {
  final double buttonTop;
  final double buttonRight;

  const Guide({Key? key, this.buttonTop = 4, this.buttonRight = 4})
    : super(key: key);

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  String category = 'Lesson';
  int currentPage = 0;
  bool showGuide = false;

  // Data for pages by category
  final Map<String, List<Map<String, String>>> pages = {
    'Lesson': [
      {
        'title': 'Variable Types',
        'description':
            'Variables can be one of three types: Strings, Numbers, Booleans. Strings can be any combination of letters and must be typed between quotation marks. For example, "Word" would be a string. Something like Word or 16 would not be strings. To convert numbers to strings, use the To String block. The second variable type are numbers. Numbers are any combination of number characters, with no letters included. For example, 16 would be a number. "16" or Sixteen would not be numbers. The final type of variables are booleans. Booleans can only be one of two things: true or false. For example, true would be a boolean. "true" or 1 would not be booleans. Some functions require a specific type of variable. Using the wrong type will result in either an error or an unintentional result.',
      },
      {
        'title': 'Defining Variables',
        'description':
            'Custom variables can be defined using the Def [BLANK] as [BLANK] code block. The first parameter of the function is the name of the variable, formatted like a string but with no quotation marks. The second parameter of the define block is the value of it. This value can be any type of variable, such as strings, numbers, or booleans. Once a define code block is added to the main chain with its parameters set, when running the code, the variable will be created once it gets to the point the define block is. There are two other parts to variables: getting and setting variables. To get a variables value to use in other blocks, use the Var [BLANK] block. This block is a variable instead of a function, meaning you can drag it into blanks. To set the value of variables to something else, use the Upd [BLANK] to [BLANK] function block. The first parameter is the variable name, which can be obtained using the Var [BLANK] block. The second parameter is what you are setting the variable to, with similar conditions as when defining a variable. These 3 blocks are the foundation to custom variables.',
      },
      {
        'title': 'Conditionals and Loops',
        'description':
            'The base of conditionals and loops are boolean variables. Depending on whether the boolean is true or false, conditionals will execute different parts of logic. The main example of this for conditionals are the blocks If [BLANK] and else. When a boolean variable is put into an If block, if the boolean value is true, all blocks starting from the if all the way to its end (signified by Close block) will be executed. If the boolean value is false, it will skip all of these blocks. If an else is put between an If block and a Close block, the blocks between the If and the Else will execute if the boolean value is true, and the blocks between the else and the close will execulte of the boolean value is false. You can think if it as if something is true, it will do this. Or Else, it will do this instead. Loops can also use conditionals. There are two types of loops, Repeat For and Repeat While. In a programming language like python, a Repeat For loop would be a For loop, while a Repeat While loop would be a While loop. Repeat For loops repeat a certain amount of times based on a number, so we wont be focused on those. The loop using conditionals is Repeat While. This block loops repeatedly until the boolean value in its parameter becomes true. ',
      },
    ],
    'Code': [
      // Always accessible
      {
        'title': 'Forward',
        'description': 'Moves the robot forward by one step.',
      },
      {
        'title': 'Backward',
        'description': 'Moves the robot backward by one step.',
      },
      {
        'title': 'Rotate Left',
        'description': 'Rotates the robot 90 degrees to the left.',
      },
      {
        'title': 'Rotate Right',
        'description': 'Rotates the robot 90 degrees to the right.',
      },
      {
        'title': 'Delay [BLANK]',
        'description':
            'Pauses the execution of code for the specified amount of time.',
      },

      // After level 2
      {
        'title': 'Interact',
        'description':
            'Execute when facing buttons to open doors. Available through the Claw module.',
      },

      // After level 6
      {
        'title': 'Def [BLANK] as [BLANK]',
        'description':
            'Defines a new variable with a specific value. The variable becomes accessible only after its creation in the chain.',
      },
      {
        'title': '[BLANK] + [BLANK]',
        'description': 'Adds two values together.',
      },
      {
        'title': '[BLANK] - [BLANK]',
        'description': 'Subtracts the second value from the first.',
      },
      {
        'title': '[BLANK] x [BLANK]',
        'description': 'Multiplies two values together.',
      },
      {
        'title': '[BLANK] / [BLANK]',
        'description': 'Divides the first value by the second.',
      },
      {
        'title': '[BLANK] % [BLANK]',
        'description':
            'Finds the remainder when the first value is divided by the second.',
      },
      {
        'title': 'Random [BLANK] to [BLANK]',
        'description':
            'Generates a random value within the specified range. Specified range is inclusive.',
      },
      {
        'title': 'Sub [BLANK] to [BLANK] of [BLANK]',
        'description':
            'Extracts a substring between two indexes of the specified text. Indexes are inclusive.',
      },
      {
        'title': 'Length [BLANK]',
        'description': 'Determines the length of the given string.',
      },
      {
        'title': '[BLANK] To String',
        'description': 'Converts a number to its string representation.',
      },

      // After level 9
      {
        'title': 'Receive',
        'description':
            'Receive a value that cannot be viewed directly, but can be stored in a variable for later use. Available through the Radar module.',
      },

      // After level 12
      {
        'title': '[BLANK] contains [BLANK]',
        'description': 'Checks if the first value contains the second value.',
      },
      {
        'title': '[BLANK] > [BLANK]',
        'description': 'Checks if the first value is greater than the second.',
      },
      {
        'title': '[BLANK] < [BLANK]',
        'description': 'Checks if the first value is less than the second.',
      },
      {
        'title': '[BLANK] == [BLANK]',
        'description': 'Checks if the two values are equal.',
      },
      {
        'title': '[BLANK] and [BLANK]',
        'description': 'Checks if both conditions are true.',
      },
      {
        'title': '[BLANK] or [BLANK]',
        'description': 'Checks if at least one of the conditions is true.',
      },
      {
        'title': 'Not [BLANK]',
        'description':
            'Inverts the condition, returning true if it is false and vice versa.',
      },
      {
        'title': 'If [BLANK]',
        'description':
            'Executes blocks of code below if the condition is true. Make sure to end If blocks with an End block. ',
      },
      {
        'title': 'End',
        'description':
            'Marks the end of an If block, ensuring that all actions following an "if" or "else" statement are properly terminated.',
      },
      {
        'title': 'Else',
        'description':
            'Executes a block of code if the condition in the preceding "if" statement is false.',
      },
      {'title': 'Break', 'description': 'Exits the current loop immediately.'},
      {
        'title': 'Repeat for [BLANK]',
        'description': 'Repeats a block of code a specified number of times.',
      },
      {
        'title': 'Repeat while [BLANK]',
        'description': 'Repeats a block of code while a condition is true.',
      },

      // After level 15
      {
        'title': 'Listen',
        'description':
            'Receive a boolean value indicating whether the Boulder block in front is about to fall. Available through the Microphone module.',
      },

      // After level 18
      {
        'title': 'Left',
        'description':
            'Moves the robot left by one step. Available through the Mecanum Wheel module.',
      },
      {
        'title': 'Right',
        'description':
            'Moves the robot right by one step. Available through the Mecanum Wheel module.',
      },
      {
        'title': 'Diag FL',
        'description':
            'Moves the robot diagonally both forward and left by one step. Available through the Mecanum Wheel module.',
      },
      {
        'title': 'Diag FR',
        'description':
            'Moves the robot diagonally both forward and right by one step. Available through the Mecanum Wheel module.',
      },
      {
        'title': 'Diag BL',
        'description':
            'Moves the robot diagonally both backward and left by one step. Available through the Mecanum Wheel module.',
      },
      {
        'title': 'Diag BR',
        'description':
            'Moves the robot diagonally both backward and right by one step. Available through the Mecanum Wheel module.',
      },

      // After level 21
      {
        'title': 'Scan',
        'description':
            'Execute when above a Note block or in front of a lazer to receive a value. This value cannot be viewed directly, but can be stored in a variable for later use. Available through the Scanner module.',
      },
    ],
    'Map': [
      {
        'title': 'Conveyor',
        'description':
            'A moving platform that transports the rover in a specific direction. The rover can still perform movements while being carried along the conveyor.',
        'image': 'Conveyor.png',
      },

      // After level 2
      {
        'title': 'Button',
        'description':
            'A button that opens a door when pressed. Interact with it using the Claw module.',
        'image': 'Button.png',
      },
      {
        'title': 'Door',
        'description': 'A door that opens when triggered by a button.',
        'image': 'Door.png',
      },

      // After level 6
      {
        'title': 'Quicksand',
        'description':
            'A tile that slows movement, halving the speed of movement. Movement blocks will take twice as long to traverse when on this tile.',
        'image': 'Quicksand.png',
      },

      // After level 9
      {
        'title': 'Hole',
        'description':
            'A hole in the ground that can cause the player to fall through. The timing of the hole opening varies.',
        'image': 'Hole.png',
      },

      // After level 12
      {
        'title': 'Ice',
        'description':
            'A slippery surface that causes the rover to slide in the direction it was last moved. Any attempts to move while sliding on ice will be ignored.',
        'image': 'Ice.png',
      },

      // After level 15
      {
        'title': 'Boulder',
        'description':
            'A dangerous tile that falls unpredictably, potentially crushing the rover. The timing of the boulders falling varies. Listen to detect when the boulders will fall using the Microphone module.',
        'image': 'Boulder.png',
      },

      // After level 18
      {
        'title': 'Acid',
        'description':
            'A hazardous liquid that incinerates the rover on contact, automatically ending the run.',
        'image': 'Acid.png',
      },
      {
        'title': 'Oil',
        'description':
            'A slippery surface that causes the rover to slide in the direction it was last moved. Any attempts to move while sliding on oil will be ignored.',
        'image': 'Oil.png',
      },

      // After level 21
      {
        'title': 'Laser',
        'description':
            'A hazardous energy beam that destroys the rover on contact. The lasers activation timing varies. Scan the laser to determine if it is active using the Scanner module.',
        'image': 'Laser.png',
      },
      {
        'title': 'Note',
        'description':
            'A note containing a value. Scan the note using the Scanner module.',
        'image': 'Note.png',
      },
      {
        'title': 'Code Door',
        'description': 'A door that requires a specific code to open.',
        'image': 'CodeDoor.png',
      },
    ],
    'Modules': [
      {
        'title': 'Claw',
        'description':
            'A module designed to interact with buttons, triggering their actions. Use the Interact function to execute this feature.',
        'image': 'Claw.png',
      },
      {
        'title': 'Omni Wheels',
        'description':
            'Wheels featuring smaller wheels within them. Omni wheels enable faster turns and allow your rover to disregard conveyor movement when positioned sideways.',
        'image': 'Omni.png',
      },
      {
        'title': 'Treads',
        'description':
            'Treads that encircle two wheels, similar to a tank. They provide faster movement, though turning is slower. Treads also negate the effects of quicksand.',
        'image': 'Treads.png',
      },
      {
        'title': 'Radar',
        'description':
            'A module capable of receiving data across the map. Use the Receive variable to execute this feature. ',
        'image': 'Radar.png',
      },
      {
        'title': 'Microphone',
        'description':
            'A module designed to detect boulder falls. Use the Listen variable to execute this feature. ',
        'image': 'Microphone.png',
      },
      {
        'title': 'Mecanum Wheels',
        'description':
            'Wheels featuring angled smaller wheels within them, allowing the rover to move sideways and diagonally. ',
        'image': 'Mecanum.png',
      },
      {
        'title': 'Scanner',
        'description':
            'A module capable of scanning notes around the map. Use the Scan variable to execute this feature. ',
        'image': 'Scanner.png',
      },
    ],
  };

  void handleNextPage() {
    if (currentPage < pages[category]!.length - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void handlePreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  String? getImage(String? imageName) {
    if (imageName == null) return null;

    final Map<String, String> imageMap = {
      'Button.png': 'assets/images/Area1Tiles/Button.png',
      'Conveyor.png': 'assets/images/Area1Tiles/ConvF.png',
      'Door.png': 'assets/images/Area1Tiles/DoorClosed.png',
      'Hole.png': 'assets/images/Area2Tiles/Hole2.png',
      'Quicksand.png': 'assets/images/Area2Tiles/Quicksand.png',
      'Boulder.png': 'assets/images/Area3Tiles/Boulder2.png',
      'Ice.png': 'assets/images/Area3Tiles/Ice.png',
      'Acid.png': 'assets/images/Area4Tiles/Acid.png',
      'CodeDoor.png': 'assets/images/Area4Tiles/DoorClosed.png',
      'Laser.png': 'assets/images/Area4Tiles/Lazer.png',
      'Note.png': 'assets/images/Area4Tiles/Note.png',
      'Oil.png': 'assets/images/Area4Tiles/Oil.png',
      'Claw.png': 'assets/images/RoverParts/RoverClaw1.png',
      'Omni.png': 'assets/images/RoverParts/OmniWheel.png',
      'Treads.png': 'assets/images/RoverParts/Track.png',
      'Radar.png': 'assets/images/RoverParts/RoverDish2.png',
      'Microphone.png': 'assets/images/RoverParts/RoverMicrophone.png',
      'Mecanum.png': 'assets/images/RoverParts/MecanumWheel.png',
      'Scanner.png': 'assets/images/RoverParts/RoverScanner.png',
    };

    return imageMap[imageName];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Guide Button
        Positioned(
          top: widget.buttonTop,
          left: widget.buttonRight,
          child: GestureDetector(
            onTap: () {
              setState(() {
                showGuide = true;
              });
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey, width: 6),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/guide.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // Guide Overlay
        if (showGuide)
          Stack(
            children: [
              // Black overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showGuide = false;
                    });
                  },
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),

              // Main guide container
              Center(
                child: Container(
                  width: 700,
                  height: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2a2a2a),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey, width: 8),
                  ),
                  child: Row(
                    children: [
                      // Sidebar
                      Container(
                        width: 128,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Close button
                            Positioned(
                              bottom: 8,
                              left: 12,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showGuide = false;
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

                            // Category buttons
                            Column(
                              children: pages.keys.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category = item;
                                      currentPage = 0;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 16,
                                    ),
                                    color: category == item
                                        ? Colors.grey
                                        : Colors.transparent,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Color(0xFFF0F0F0),
                                        fontFamily: 'SpaceMono',
                                        fontSize: 22,
                                        height: 1.36,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      // Content area
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Title and Image Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Title
                                  Flexible(
                                    child: Text(
                                      pages[category]![currentPage]['title']!,
                                      style: const TextStyle(
                                        color: Color(0xFFF0F0F0),
                                        fontFamily: 'SpaceMono',
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // Image if exists
                                  if (pages[category]![currentPage].containsKey(
                                    'image',
                                  ))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        getImage(
                                          pages[category]![currentPage]['image'],
                                        )!,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                ],
                              ),

                              // Description
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    pages[category]![currentPage]['description']!,
                                    style: const TextStyle(
                                      color: Color(0xFFF0F0F0),
                                      fontFamily: 'SpaceMono',
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),

                              // Navigation Buttons
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: currentPage > 0
                                          ? handlePreviousPage
                                          : null,
                                      child: Image.asset(
                                        'assets/images/leftIcon.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        color: currentPage > 0
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap:
                                          currentPage <
                                              pages[category]!.length - 1
                                          ? handleNextPage
                                          : null,
                                      child: Image.asset(
                                        'assets/images/rightIcon.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        color:
                                            currentPage <
                                                pages[category]!.length - 1
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
