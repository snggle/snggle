import 'package:codec_utils/codec_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RecordAudioPageState extends Equatable {
  final bool loadingBool;
  final ACborTaggedObject? cborTaggedObject;
  final Widget? audioResultPage;

  const RecordAudioPageState({
    this.loadingBool = false,
    this.cborTaggedObject,
    this.audioResultPage,
  });

  RecordAudioPageState copyWith({
    bool? loadingBool,
    ACborTaggedObject? cborTaggedObject,
    Widget? audioResultPage,
  }) {
    return RecordAudioPageState(
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
