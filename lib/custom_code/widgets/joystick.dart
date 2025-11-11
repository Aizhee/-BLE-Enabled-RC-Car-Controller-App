// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Note: You must add the dependency 'flutter_joystick: ^0.0.3' in pubspec.yaml
import 'package:flutter_joystick/flutter_joystick.dart' as Joysticks;

class Joystick extends StatefulWidget {
  const Joystick({
    Key? key,
    this.width,
    this.height,
    this.size = 100,
    this.device, // Your device parameter
    this.onMove, // ---- ADD THIS PARAMETER ----
  }) : super(key: key);

  final double? width;
  final double? height;
  final double size;
  final BTDeviceStruct? device;

  // Define the Action parameter. It will pass a String (the command).
  final Future<dynamic> Function(String)? onMove;

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  String _lastCommand = ''; // Add this to prevent spamming

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Joysticks.Joystick(
        base: Joysticks.JoystickBase(
          decoration: Joysticks.JoystickBaseDecoration(
            color: Colors.black,
            drawOuterCircle: false,
          ),
          arrowsDecoration: Joysticks.JoystickArrowsDecoration(
            color: Colors.blue,
          ),
        ),
        // ---- THIS LISTENER IS MODIFIED ----
        listener: (details) {
          if (widget.device == null) return;

          String command = '';
          final x = details.x;
          final y = details.y;

          // Main directions
          if (x.abs() < 0.3 && y < -0.3) {
            command = 'F';
          } else if (x.abs() < 0.3 && y > 0.3) {
            command = 'B';
          } else if (x < -0.3 && y.abs() < 0.3) {
            command = 'L';
          } else if (x > 0.3 && y.abs() < 0.3) {
            command = 'R';
          }
          // Diagonal directions
          else if (x < -0.3 && y < -0.3) {
            command = 'Q';
          } else if (x > 0.3 && y < -0.3) {
            command = 'E';
          } else if (x < -0.3 && y > 0.3) {
            command = 'Z';
          } else if (x > 0.3 && y > 0.3) {
            command = 'C';
          }

          // If the command is new and not empty
          if (command.isNotEmpty && command != _lastCommand) {
            _lastCommand = command; // Save the last command

            // Check if the 'onMove' action is assigned
            if (widget.onMove != null) {
              // Execute the action and pass the 'command' string
              widget.onMove!(command);
            }
          }
        },
      ),
    );
  }
}
