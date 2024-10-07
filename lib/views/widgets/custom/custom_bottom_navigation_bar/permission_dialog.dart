import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  final VoidCallback close;
  final VoidCallback show;

  const PermissionDialog({
    required this.close,
    required this.show,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Dialog(
          child: Text('Panie, permisje se Pan daj, bo se Pan normalnie nie zeskanujesz w mordę jeża'),
        ),
        OutlinedButton(
            onPressed: () async {
              PermissionStatus newStatus = await Permission.camera.request();
              if (newStatus.isDenied) {
                print('Camera permission denied');
                close();
              } else if (newStatus.isGranted) {
                print('Camera permission granted');
                close();
                show();
              }
            },
            child: const Text('nadaj uprawnienia')),
      ],
    );
  }
}
