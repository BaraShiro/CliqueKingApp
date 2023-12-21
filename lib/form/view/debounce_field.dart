import 'dart:async';
import 'package:flutter/material.dart';

/// A custom [TextFormField] with asynchronous validation and debounce
///
/// Adapted from [Async TextFormField](https://github.com/snippetkid/async_textformfield)
class DebounceField extends StatefulWidget {
  final Future<bool> Function(String) validator;
  final Duration debounceDelay;
  final TextEditingController controller;
  final bool obscureText;
  final String isValidatingMessage;
  final String isEmptyMessage;
  final String isInvalidMessage;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  const DebounceField({
    super.key,
    required this.validator,
    required this.debounceDelay,
    required this.controller,
    this.obscureText = false,
    this.isValidatingMessage = "Validating...",
    this.isEmptyMessage = "Field can not be empty",
    this.isInvalidMessage = "Field has an invalid value",
    this.keyboardType,
    this.decoration,
  });

  @override
  State<StatefulWidget> createState() => _DebounceFiledState();
}

class _DebounceFiledState extends State<DebounceField>{
  Timer? _debounce;
  bool isValidating = false;
  bool isValid = false;
  bool isDirty = false;
  bool isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (isValidating) {
          return widget.isValidatingMessage;
        }
        if (value?.isEmpty ?? false) {
          return  widget.isEmptyMessage;
        }
        if (!isWaiting && !isValid) {
          return  widget.isInvalidMessage;
        }
        return null;
      },
      onChanged: (text) async {
        isDirty = true;
        if (text.isEmpty) {
          setState(() {
            isValid = false;
          });
          cancelTimer();
          return;
        }
        isWaiting = true;
        cancelTimer();
        _debounce = Timer(widget.debounceDelay, () async {
          isWaiting = false;
          isValid = await validate(text);
          setState(() {});
          isValidating = false;
        });
      },
      keyboardType: widget.keyboardType,
      decoration: widget.decoration,
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
  }

  Future<bool> validate(String text) async {
    setState(() {
      isValidating = true;
    });
    final bool isValid = await widget.validator(text);
    isValidating = false;
    return isValid;
  }

}