import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartDropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final SmartDropdownController controller;

  const SmartDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.controller,
  }) : super(key: key);

  @override
  _SmartDropdownState createState() => _SmartDropdownState();
}

class SmartDropdownController extends ChangeNotifier {
  String? _value;

  String? get value => _value;

  void setValue(String? newValue) {
    _value = newValue;
    notifyListeners();
  }

  void setDefault() {
    setValue(null);
  }
}

class _SmartDropdownState extends State<SmartDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.controller.value;

    widget.controller.addListener(() {
      setState(() {
        _selectedValue = widget.controller.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedValue,
          isExpanded: true,
          items: widget.items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              widget.controller.setValue(value);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }
}