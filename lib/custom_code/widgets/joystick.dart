// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_joystick/flutter_joystick.dart' as Joysticks;

class Joystick extends StatefulWidget {
  const Joystick({
    Key? key,
    this.width,
    this.height,
    this.size = 300,
    this.device,
    this.onMove,
    this.joystickMap,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double size;
  final BTDeviceStruct? device;
  final Future<dynamic> Function(String)? onMove;
  final List<String>? joystickMap;

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  // Helper function to safely get commands from the map
  String _getCommand(int index) {
    // Checks if the map is valid and long enough
    if (widget.joystickMap != null && widget.joystickMap!.length > index) {
      return widget.joystickMap![index];
    }
    return ""; // Return empty string if map isn't set up
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Joysticks.Joystick(
        base: Joysticks.JoystickBase(
          size: 300,
          decoration: Joysticks.JoystickBaseDecoration(
            color: Colors.black,
            drawOuterCircle: false,
          ),
          arrowsDecoration: Joysticks.JoystickArrowsDecoration(
            color: Colors.blue,
          ),
        ),

        // ---- LISTENER LOGIC UPDATED TO MATCH YOUR MAP ----
        listener: (details) {
          if (widget.device == null || widget.onMove == null) return;

          final x = details.x;
          final y = details.y;

          String finalCommand = "";
          String _lastCommand = "";

          // Your map: F,B,R,L,Q,E,Z,C,S
          // This logic now matches that order.

          // Main directions
          if (x.abs() < 0.3 && y < -0.3) {
            finalCommand = _getCommand(0); // F (Forward)
          } else if (x.abs() < 0.3 && y > 0.3) {
            finalCommand = _getCommand(1); // B (Backward)
          } else if (x > 0.3 && y.abs() < 0.3) {
            finalCommand = _getCommand(2); // R (Right)
          } else if (x < -0.3 && y.abs() < 0.3) {
            finalCommand = _getCommand(3); // L (Left)
          }
          // Diagonal directions
          else if (x < -0.3 && y < -0.3) {
            finalCommand = _getCommand(4); // Q (Forward-Left)
          } else if (x > 0.3 && y < -0.3) {
            finalCommand = _getCommand(5); // E (Forward-Right)
          } else if (x < -0.3 && y > 0.3) {
            finalCommand = _getCommand(6); // Z (Backward-Left)
          } else if (x > 0.3 && y > 0.3) {
            finalCommand = _getCommand(7); // C (Backward-Right)
          }
          // ---- "STOP" COMMAND ADDED BACK ----
          else {
            // This is the centered/deadzone position
            finalCommand = _getCommand(8); // S (Stop)
          }

          // This sends the mapped command (e.g., "move_forward" or "stop_motor")
          // or nothing if the command string in your map is empty.
          // Send only when command changes
          if (finalCommand.isNotEmpty && finalCommand != _lastCommand) {
            _lastCommand = finalCommand;
            widget.onMove!(finalCommand);
          }
        },
      ),
    );
  }
}
