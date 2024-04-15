import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/a_timed_pin_confirmation_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/states/timed_pin_confirmation_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/timed_pin_confirmation/timed_pin_confirmation_page_cubit.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/generic/circular_timer/circular_timer.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class TimedPinConfirmationPage extends StatefulWidget {
  const TimedPinConfirmationPage({super.key});

  @override
  State<StatefulWidget> createState() => _TimedPinConfirmationPageState();
}

class _TimedPinConfirmationPageState extends State<TimedPinConfirmationPage> {
  static const int _confirmationTime = 10;

  final TimedPinConfirmationPageCubit categoryRemovalPageCubit = TimedPinConfirmationPageCubit();
  final ValueNotifier<int> confirmationTimeNotifier = ValueNotifier<int>(_confirmationTime);
  late final Timer confirmationTimer;

  @override
  void initState() {
    super.initState();
    confirmationTimer = Timer.periodic(
      const Duration(seconds: 1),
      _handleTimerTick,
    );
  }

  @override
  void dispose() {
    categoryRemovalPageCubit.close();
    if (confirmationTimer.isActive) {
      confirmationTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimedPinConfirmationPageCubit, ATimedPinConfirmationPageState>(
      bloc: categoryRemovalPageCubit,
      builder: (BuildContext context, ATimedPinConfirmationPageState timedPinConfirmationPageState) {
        return ValueListenableBuilder<int>(
          valueListenable: confirmationTimeNotifier,
          builder: (BuildContext context, int remainingTime, _) {
            return PinpadScaffold(
              errorBool: timedPinConfirmationPageState is TimedPinConfirmationPageInvalidPinState,
              title: 'Pin confirmation',
              initialPinNumbers: timedPinConfirmationPageState.pinNumbers,
              timerWidget: Align(
                alignment: Alignment.centerRight,
                child: CircularTimer(
                  currentValue: remainingTime,
                  initialValue: _confirmationTime,
                ),
              ),
              onChanged: categoryRemovalPageCubit.updatePinNumbers,
              actionButtons: <Widget>[
                CustomTextButton(
                  title: 'Cancel',
                  onPressed: _pressCancelButton,
                ),
                if (remainingTime == 0)
                  CustomTextButton(
                    title: 'Confirm',
                    onPressed: _pressConfirmButton,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleTimerTick(Timer timer) {
    if (confirmationTimeNotifier.value == 0) {
      timer.cancel();
    } else {
      confirmationTimeNotifier.value = confirmationTimeNotifier.value - 1;
    }
  }

  Future<void> _pressCancelButton() async {
    Navigator.of(context).pop(false);
  }

  Future<void> _pressConfirmButton() async {
    try {
      await categoryRemovalPageCubit.authenticate();
      Navigator.of(context).pop(true);
    } catch (e) {
      AppLogger().log(message: 'Invalid pin', logLevel: LogLevel.debug);
    }
  }
}
