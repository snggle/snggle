import 'package:flutter/material.dart';

class CompleteScanPage extends StatefulWidget {
  final String decodedString;

  const CompleteScanPage({required this.decodedString, super.key});

  @override
  State<CompleteScanPage> createState() => _CompleteScanPageState();
}

class _CompleteScanPageState extends State<CompleteScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Completely Scanned')),
      body: Center(
        child: Text(widget.decodedString),
      ),
    );
  }
}
