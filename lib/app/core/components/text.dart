import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';
import 'package:vitrine_ufma/app/core/utils/text_styles.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontWeight;
  final Color? color;
  final double? letterSpacing;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final Color? decorationColor;
  final double? decorationThickness;
  final bool? replaceAsterisks;
  const AppText({
    super.key,
    required this.text,
    this.fontSize = AppFontSize.fz05,
    this.fontWeight = "regular",
    this.color,
    this.letterSpacing,
    this.textAlign,
    this.height,
    this.maxLines,
    this.decoration,
    this.fontStyle,
    this.decorationColor,
    this.decorationThickness,
    this.replaceAsterisks,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeCustom theme = Theme.of(context).extension<ThemeCustom>()!;
    return Container(
      color: Colors.transparent,
      child: EasyRichText(
        text,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        defaultStyle: textStyle(
            color: color ?? theme.textColor,
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize,
            fontStyle: fontStyle,
            height: height,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationThickness: decorationThickness,
            letterSpacing: letterSpacing),
        patternList: [
          //
          //#gfdgfgfgfgfgg#dsdsds
          //#gfdgdfgdfg#
          //dsdsdsd{Afttdfgdf65656dfdf}}fhgh{frgfgfg}dfd
          EasyRichTextPattern(
            targetString: '(\\*)(.*?)(\\*)',
            matchBuilder: (BuildContext? context, RegExpMatch? match) {
              return TextSpan(
                text: (replaceAsterisks ?? true)
                    ? match![0]!.replaceAll('*', '')
                    : match![0]!,
                style: textStyle(
                    color: color,
                    height: height,
                    fontSize: fontSize,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: "bold",
                    decoration: decoration,

                    // decorationColor: decorationColor,
                    // decorationThickness: decorationThickness,
                    letterSpacing: letterSpacing),
              );
            },
          ),
        ],
      ),
    );
  }
}
