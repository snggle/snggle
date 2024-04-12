import 'package:flutter/material.dart';

class GifButton extends StatelessWidget {
  final String label;
  final String gifPath;
  final VoidCallback onPressed;

  const GifButton({
    required this.label,
    required this.gifPath,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onPressed,
        child: Column(
          children: <Widget>[
            Image.asset(gifPath, width: 124, height: 124),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
