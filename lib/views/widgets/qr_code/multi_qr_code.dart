import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:snggle/bloc/multi_qr_code/multi_qr_code_cubit.dart';
import 'package:snggle/shared/utils/multi_qr_code_utils.dart';
import 'package:snggle/views/widgets/qr_code/qr_code_item.dart';

class MultiQrCode extends StatefulWidget {
  final String dataString;
  final int autoPlayDelay;
  final int maxCharacters;
  final int qrErrorCorrectionLevel;
  final String name;
  final String type;
  final bool advancedOptions;
  final bool autoPlayBool;
  final bool loopBool;
  final double borderRadius;
  final double itemWidth;
  final double itemHeight;
  final Color backgroundColor;
  final Color qrCodeColor;
  final Duration qrCodeDuration;

  const MultiQrCode({
    required this.dataString,
    this.autoPlayDelay = 0,
    this.maxCharacters = 200,
    this.qrErrorCorrectionLevel = QrErrorCorrectLevel.H,
    this.name = '',
    this.type = '',
    this.advancedOptions = false,
    this.autoPlayBool = true,
    this.loopBool = true,
    this.borderRadius = 10,
    this.itemWidth = 300,
    this.itemHeight = 300,
    this.backgroundColor = Colors.white,
    this.qrCodeColor = Colors.black,
    this.qrCodeDuration = const Duration(milliseconds: 500),
    super.key,
  })  : assert(maxCharacters > 0, 'maxCharacters must be bigger than 0'),
        assert(name.length < 20, 'name must be less than 20'),
        assert(type.length < 10, 'type must be less than 10');

  @override
  State<MultiQrCode> createState() => _MultiQrCodeState();
}

class _MultiQrCodeState extends State<MultiQrCode> {
  final List<bool> _maxCharacterToggleBool = <bool>[false, true, false];
  final List<bool> _qrAnimationDurationToggleBool = <bool>[false, true, false];

  late final MultiQrCodeCubit multiQrCodeCubit = MultiQrCodeCubit(
    maxCharacters: widget.maxCharacters,
    qrAnimationDuration: widget.qrCodeDuration,
  );

  @override
  Widget build(BuildContext context) {
    final CustomLayoutOption customLayoutOption = CustomLayoutOption(startIndex: 0, stateCount: 5);

    return BlocBuilder<MultiQrCodeCubit, MultiQrCodeState>(
      bloc: multiQrCodeCubit,
      builder: (BuildContext context, MultiQrCodeState multiQrCodeState) {
        List<String> qrDataList = MultiQrCodeUtils.splitQrCodeData(dataString: widget.dataString, maxCharacters: multiQrCodeState.maxCharacters, name: widget.name, type: widget.type);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Swiper(
              autoplay: widget.autoPlayBool,
              autoplayDelay: widget.autoPlayDelay,
              customLayoutOption: customLayoutOption,
              duration: multiQrCodeState.qrAnimationDuration.inMilliseconds,
              itemCount: qrDataList.length,
              itemHeight: widget.itemHeight,
              itemWidth: widget.itemWidth,
              itemBuilder: (BuildContext context, int index) {
                return QrCodeItem(
                  qrErrorCorrectionLevel: widget.qrErrorCorrectionLevel,
                  borderRadius: widget.borderRadius,
                  qrData: qrDataList[index],
                  backgroundColor: widget.backgroundColor,
                  qrColor: widget.qrCodeColor,
                );
              },
              layout: SwiperLayout.CUSTOM,
              loop: widget.loopBool,
            ),
            if (widget.advancedOptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text('Animation Speed'),
                      ToggleButtons(
                        isSelected: _qrAnimationDurationToggleBool,
                        onPressed: (int selectedQrAnimationIndex) => _toggleQrAnimationDuration(selectedQrAnimationIndex, context),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,
                        children: const <Text>[
                          Text('S'),
                          Text('M'),
                          Text('F'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Text('Data Density'),
                      ToggleButtons(
                        isSelected: _maxCharacterToggleBool,
                        onPressed: (int selectedMaxCharactersIndex) => _toggleMaxCharacters(selectedMaxCharactersIndex, context),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,
                        children: const <Text>[
                          Text('S'),
                          Text('M'),
                          Text('L'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  void _toggleMaxCharacters(int selectedMaxCharactersIndex, BuildContext context) {
    for (int i = 0; i < _maxCharacterToggleBool.length; i++) {
      _maxCharacterToggleBool[i] = false;
    }
    _maxCharacterToggleBool[selectedMaxCharactersIndex] = true;

    if (selectedMaxCharactersIndex == 0) {
      multiQrCodeCubit.toggleMaxCharacters(100);
    } else if (selectedMaxCharactersIndex == 1) {
      multiQrCodeCubit.toggleMaxCharacters(200);
    } else {
      multiQrCodeCubit.toggleMaxCharacters(500);
    }
  }

  void _toggleQrAnimationDuration(int selectedDurationIndex, BuildContext context) {
    for (int i = 0; i < _qrAnimationDurationToggleBool.length; i++) {
      _qrAnimationDurationToggleBool[i] = false;
    }
    _qrAnimationDurationToggleBool[selectedDurationIndex] = true;

    if (selectedDurationIndex == 0) {
      multiQrCodeCubit.toggleQrAnimationDuration(const Duration(milliseconds: 1000));
    } else if (selectedDurationIndex == 1) {
      multiQrCodeCubit.toggleQrAnimationDuration(const Duration(milliseconds: 500));
    } else {
      multiQrCodeCubit.toggleQrAnimationDuration(const Duration(milliseconds: 250));
    }
  }
}
