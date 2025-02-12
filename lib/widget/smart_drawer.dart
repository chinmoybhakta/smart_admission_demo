import 'package:flutter/material.dart';

class SmartDrawer extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color color;

  const SmartDrawer({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      onTap: onTap,
    );
  }
}