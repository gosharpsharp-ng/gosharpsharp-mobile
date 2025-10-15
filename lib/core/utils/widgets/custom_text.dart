
import 'package:gosharpsharp/core/utils/exports.dart';

Widget customText(String text,
    {Color? color,
      double fontSize = 14,
      double? letterSpacing,
      double? height,
      TextAlign? textAlign,
      int? maxLines,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextDecoration? decoration,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      String fontFamily='HelveticaNeue',
      bool blur = false}) {
  // Check if text contains Naira sign (₦) and handle it specially
  if (text.contains('₦')) {
    return _buildRichTextWithNaira(
      text,
      color: color,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      height: height,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      decoration: decoration,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
    );
  }

  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: true,
    style: TextStyle(
      fontFamily: fontFamily,
      color: color,
      letterSpacing: letterSpacing,
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
    ),
  );
}

/// Helper function to build RichText with Naira sign using a different font
Widget _buildRichTextWithNaira(
  String text, {
  Color? color,
  double fontSize = 14,
  double? letterSpacing,
  double? height,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow overflow = TextOverflow.ellipsis,
  TextDecoration? decoration,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  String fontFamily = 'HelveticaNeue',
}) {
  // Split text by Naira sign
  final parts = text.split('₦');
  final spans = <TextSpan>[];

  for (int i = 0; i < parts.length; i++) {
    // Add the text part with custom font
    if (parts[i].isNotEmpty) {
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontFamily: fontFamily,
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
          ),
        ),
      );
    }

    // Add Naira sign with Roboto font (except for last iteration)
    if (i < parts.length - 1) {
      spans.add(
        TextSpan(
          text: '₦',
          style: TextStyle(
            fontFamily: 'Roboto', // Use Roboto font for Naira sign
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
          ),
        ),
      );
    }
  }

  return Text.rich(
    TextSpan(children: spans),
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: true,
  );
}