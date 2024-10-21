import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class ETHAddressPreview extends StatelessWidget {
  final String address;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const ETHAddressPreview({
    required this.address,
    this.textStyle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? finalTextStyle = (textStyle ?? textTheme.bodyMedium)?.copyWith(height: 1);

    double iconSize = (finalTextStyle?.fontSize ?? 16) * 2;

    return CopyWrapper(
      value: address,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: SvgPicture.string(
              Blockies(seed: address).toSvg(size: iconSize.toInt()),
              fit: BoxFit.cover,
              width: iconSize,
              height: iconSize,
            ),
          ),
          const SizedBox(width: 10),
          if (finalTextStyle?.color != null)
            Expanded(child: Text(address, style: finalTextStyle))
          else
            Expanded(
              child: GradientText(
                address,
                gradient: const RadialGradient(
                  radius: 10,
                  center: Alignment(-0.6, -0.6),
                  colors: <Color>[
                    Color(0xFF000000),
                    Color(0xFF42D2FF),
                    Color(0xFF939393),
                    Color(0xFF000000),
                  ],
                ),
                textStyle: finalTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
