# Roverdrive Flutter

Sandbox for controlling a rover in a 3d scene with simple commands.

![Screenshot_20260215_195454](https://github.com/user-attachments/assets/8a3b6328-967d-4810-85a6-5d87f286e2cd)

App Demo: https://youtu.be/Bf5n60Z1Yp4?si=ithRc7_VueFua3NQ

## Scenes
- **Main Menu:** App logo + animated rover video with button to enter Sandbox.
- **Sandbox:** Create a chain of commands to control a rover. Click buttons to add them to a queue. Press execute to run your commands.
- **Map:** View the rover move accordng to your command chain from Sandbox. Created using flutter_scene.

## Commands
- **Forward:** Move forward one tile
- **Backward:** Move back one tile
- **Turn Left:** Rotate 90 degrees counterclockwise
- **Turn Right:** Rotate 90 degrees clockwise

## Tools Used
- **Flutter:** Main framework for app
- **flutter_scene:** 3D library used to display Map scene
- **Photopea:** Used to design tile textures and app's logo
