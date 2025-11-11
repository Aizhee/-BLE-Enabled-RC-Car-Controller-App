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
    this.size = 100, // This is your custom widget's parameter
    this.device,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double size;
  final BTDeviceStruct? device;

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Joysticks.Joystick(
          // This is the package's Joystick
          base: Joysticks.JoystickBase(
            decoration: Joysticks.JoystickBaseDecoration(
              color: Colors.black,
              drawOuterCircle: false,
            ),
            arrowsDecoration: Joysticks.JoystickArrowsDecoration(
              color: Colors.blue,
            ),
          ),
          listener: (details) async {
            if (widget.device == null) return;

            String command = '';
            final x = details.x;
            final y = details.y;

            // Main directions
            if (x.abs() < 0.3 && y < -0.3) {
              command = 'F'; // Forward
            } else if (x.abs() < 0.3 && y > 0.3) {
              command = 'B'; // Backward
            } else if (x < -0.3 && y.abs() < 0.3) {
              command = 'L'; // Left
            } else if (x > 0.3 && y.abs() < 0.3) {
              command = 'R'; // Right
            }
            // Diagonal directions
            else if (x < -0.3 && y < -0.3) {
              command = 'Q'; // Top-left
            } else if (x > 0.3 && y < -0.3) {
              command = 'E'; // Top-right
            } else if (x < -0.3 && y > 0.3) {
              command = 'Z'; // Bottom-left
            } else if (x > 0.3 && y > 0.3) {
              command = 'C'; // Bottom-right
            }

            if (command.isNotEmpty) {
              // Ensure sendData is imported and working
              await sendData(widget.device!, command);
            }
          }),
    );
  }
}
