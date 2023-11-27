import 'package:flutter/material.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 91,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/gifs/eyes_animation.gif'),
                  const SizedBox(height: 4),
                  const Text(
                    'LOADING',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      letterSpacing: 4,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
