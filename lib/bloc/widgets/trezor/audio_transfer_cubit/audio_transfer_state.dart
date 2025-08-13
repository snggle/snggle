import 'package:codec_utils/codec_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AudioTransferState extends Equatable {
  final bool loadingBool;
  final ACborTaggedObject? cborTaggedObject;
  final Widget? audioResultPage;

  const AudioTransferState({
    this.loadingBool = false,
    this.cborTaggedObject,
    this.audioResultPage,
  });

  AudioTransferState copyWith({
    bool? loadingBool,
    ACborTaggedObject? cborTaggedObject,
    Widget? audioResultPage,
  }) {
    return AudioTransferState(
      loadingBool: loadingBool ?? this.loadingBool,
      cborTaggedObject: cborTaggedObject ?? this.cborTaggedObject,
      audioResultPage: audioResultPage ?? this.audioResultPage,
    );
  }

  bool canReceiveAudio() {
    return loadingBool == false && _hasRecord == false && audioResultPage == null;
  }

  bool shouldLoadResultPage() {
    return loadingBool && _hasRecord && audioResultPage == null;
  }

  bool get _hasRecord => cborTaggedObject != null;

  @override
  List<Object?> get props => <Object?>[loadingBool, cborTaggedObject, audioResultPage];
}
