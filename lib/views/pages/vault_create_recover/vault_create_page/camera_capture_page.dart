import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/camera/camera_capture_page_cubit.dart';
import 'package:snggle/bloc/pages/vault_create_recover/vault_create/camera/camera_capture_page_state.dart';

@RoutePage()
class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  late final CameraCapturePageCubit _cameraCapturePageCubitCubit;

  @override
  void initState() {
    super.initState();
    _cameraCapturePageCubitCubit = CameraCapturePageCubit()..initializeCamera();
  }

  @override
  void dispose() {
    _cameraCapturePageCubitCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCapturePageCubit, CameraCapturePageState>(
      bloc: _cameraCapturePageCubitCubit,
      builder: (BuildContext context, CameraCapturePageState state) {
        if (state is CameraLoading || state is CameraInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CameraReady) {
          return Scaffold(
            appBar: AppBar(title: const Text('Capture Image')),
            body: Column(
              children: <Widget>[
                Expanded(child: CameraPreview(state.controller)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _cameraCapturePageCubitCubit.generateEntropy,
                    child: const Text('Capture'),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is CameraEntropyGenerated) {
          return Scaffold(
            appBar: AppBar(title: const Text('Entropy')),
            body: Center(
              child: Text('Entropy:\n${state.entropy}'),
            ),
          );
        }

        if (state is CameraError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        return const SizedBox();
      },
    );
  }
}
