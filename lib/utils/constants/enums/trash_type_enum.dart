import 'package:flutter/material.dart';

enum TrashTypeEnum {
  recycle(name: 'Reciclável', icon: Icons.recycling, color: Colors.green),
  furniture(name: 'Móveis', icon: Icons.chair, color: Colors.red);

  const TrashTypeEnum({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}
