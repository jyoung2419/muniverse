import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/translation_provider.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.watch<TranslationProvider>();

    return FutureBuilder<String>(
      future: translationProvider.translate(text),
      builder: (context, snapshot) {
        final displayText = snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData
            ? snapshot.data!
            : text;
        return Text(
          displayText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}