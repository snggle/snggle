import 'package:flutter/material.dart';
import 'package:snuggle/views/widgets/qr_card/qr_card.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: QrCard(
            qrData: const <String>[
              'ExampleData',
              'ExampleData;ExampleData;ExampleData',
              'ExampleData;ExampleData;ExampleData',
              'ExampleData;ExampleData;ExampleData',
              'ExampleData;ExampleData;ExampleData',
              'ExampleData;ExampleData;ExampleData',
              'ExampleData;ExampleData;ExampleData',
            ],
            charactersPerCard: 10,
          )),
        ],
      )),
    );
  }
}
