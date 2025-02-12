import 'package:flutter/material.dart';

class SmartDatepicker extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController controller;

  const SmartDatepicker({
    Key? key,
    this.labelText,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  State<SmartDatepicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<SmartDatepicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000, 2, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }
}