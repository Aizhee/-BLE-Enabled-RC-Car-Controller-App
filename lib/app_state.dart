import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _joystickmap = prefs.getStringList('ff_joystickmap') ?? _joystickmap;
    });
    _safeInit(() {
      _buttons = prefs.getStringList('ff_buttons') ?? _buttons;
    });
    _safeInit(() {
      _slidersbits = prefs.getStringList('ff_slidersbits') ?? _slidersbits;
    });
    _safeInit(() {
      _slidervals =
          prefs.getStringList('ff_slidervals')?.map(int.parse).toList() ??
              _slidervals;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// mapped values for joystick
  List<String> _joystickmap = ['F', 'B', 'R', 'L', 'Q', 'E', 'Z', 'C', 'S'];
  List<String> get joystickmap => _joystickmap;
  set joystickmap(List<String> value) {
    _joystickmap = value;
    prefs.setStringList('ff_joystickmap', value);
  }

  void addToJoystickmap(String value) {
    joystickmap.add(value);
    prefs.setStringList('ff_joystickmap', _joystickmap);
  }

  void removeFromJoystickmap(String value) {
    joystickmap.remove(value);
    prefs.setStringList('ff_joystickmap', _joystickmap);
  }

  void removeAtIndexFromJoystickmap(int index) {
    joystickmap.removeAt(index);
    prefs.setStringList('ff_joystickmap', _joystickmap);
  }

  void updateJoystickmapAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    joystickmap[index] = updateFn(_joystickmap[index]);
    prefs.setStringList('ff_joystickmap', _joystickmap);
  }

  void insertAtIndexInJoystickmap(int index, String value) {
    joystickmap.insert(index, value);
    prefs.setStringList('ff_joystickmap', _joystickmap);
  }

  List<String> _buttons = ['A', 'S', 'D', 'F'];
  List<String> get buttons => _buttons;
  set buttons(List<String> value) {
    _buttons = value;
    prefs.setStringList('ff_buttons', value);
  }

  void addToButtons(String value) {
    buttons.add(value);
    prefs.setStringList('ff_buttons', _buttons);
  }

  void removeFromButtons(String value) {
    buttons.remove(value);
    prefs.setStringList('ff_buttons', _buttons);
  }

  void removeAtIndexFromButtons(int index) {
    buttons.removeAt(index);
    prefs.setStringList('ff_buttons', _buttons);
  }

  void updateButtonsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    buttons[index] = updateFn(_buttons[index]);
    prefs.setStringList('ff_buttons', _buttons);
  }

  void insertAtIndexInButtons(int index, String value) {
    buttons.insert(index, value);
    prefs.setStringList('ff_buttons', _buttons);
  }

  List<String> _slidersbits = ['Y', 'X', 'W', 'X'];
  List<String> get slidersbits => _slidersbits;
  set slidersbits(List<String> value) {
    _slidersbits = value;
    prefs.setStringList('ff_slidersbits', value);
  }

  void addToSlidersbits(String value) {
    slidersbits.add(value);
    prefs.setStringList('ff_slidersbits', _slidersbits);
  }

  void removeFromSlidersbits(String value) {
    slidersbits.remove(value);
    prefs.setStringList('ff_slidersbits', _slidersbits);
  }

  void removeAtIndexFromSlidersbits(int index) {
    slidersbits.removeAt(index);
    prefs.setStringList('ff_slidersbits', _slidersbits);
  }

  void updateSlidersbitsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    slidersbits[index] = updateFn(_slidersbits[index]);
    prefs.setStringList('ff_slidersbits', _slidersbits);
  }

  void insertAtIndexInSlidersbits(int index, String value) {
    slidersbits.insert(index, value);
    prefs.setStringList('ff_slidersbits', _slidersbits);
  }

  List<int> _slidervals = [0, 180, 0, 255];
  List<int> get slidervals => _slidervals;
  set slidervals(List<int> value) {
    _slidervals = value;
    prefs.setStringList(
        'ff_slidervals', value.map((x) => x.toString()).toList());
  }

  void addToSlidervals(int value) {
    slidervals.add(value);
    prefs.setStringList(
        'ff_slidervals', _slidervals.map((x) => x.toString()).toList());
  }

  void removeFromSlidervals(int value) {
    slidervals.remove(value);
    prefs.setStringList(
        'ff_slidervals', _slidervals.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromSlidervals(int index) {
    slidervals.removeAt(index);
    prefs.setStringList(
        'ff_slidervals', _slidervals.map((x) => x.toString()).toList());
  }

  void updateSlidervalsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    slidervals[index] = updateFn(_slidervals[index]);
    prefs.setStringList(
        'ff_slidervals', _slidervals.map((x) => x.toString()).toList());
  }

  void insertAtIndexInSlidervals(int index, int value) {
    slidervals.insert(index, value);
    prefs.setStringList(
        'ff_slidervals', _slidervals.map((x) => x.toString()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
