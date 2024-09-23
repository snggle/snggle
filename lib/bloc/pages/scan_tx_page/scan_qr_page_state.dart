import 'package:codec_utils/codec_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ScanQRPageState extends Equatable {
  final bool loadingBool;
  final ACborTaggedObject? cborTaggedObject;
  final Widget? qrResultPage;

  const ScanQRPageState({
    this.loadingBool = false,
    this.cborTaggedObject,
    this.qrResultPage,
  });

  ScanQRPageState copyWith({
    bool? loadingBool,
    ACborTaggedObject? cborTaggedObject,
    Widget? qrResultPage,
  }) {
    return ScanQRPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      cborTaggedObject: cborTaggedObject ?? this.cborTaggedObject,
      qrResultPage: qrResultPage ?? this.qrResultPage,
    );
  }

  bool canReceiveQRCode() {
    return loadingBool == false && _hasRecord == false && qrResultPage == null;
  }

  bool shouldLoadResultPage() {
    return loadingBool && _hasRecord && qrResultPage == null;
  }

  bool get _hasRecord => cborTaggedObject != null;

  @override
  List<Object?> get props => <Object?>[loadingBool, cborTaggedObject, qrResultPage];
}
