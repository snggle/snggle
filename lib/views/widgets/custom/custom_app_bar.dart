import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.2),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}
