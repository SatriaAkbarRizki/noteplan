import 'package:flutter/material.dart';

class CustomTextEditingController extends TextEditingController {
  final Map<String, TextStyle> map;
  final Pattern pattern;

  CustomTextEditingController(this.map)
      : pattern = RegExp(map.keys.map((e) => e).join('|'), multiLine: true);

  @override
  set text(String newText) {
    value = value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
        composing: TextRange.empty);
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context, TextStyle? style, bool? withComposing}) {
    final List<InlineSpan> children = [];
    String? patternMached;
    String? formatText;
    TextStyle? myStyle;
    text.splitMapJoin(pattern, onMatch: (Match match) {
      myStyle = map[map.keys.firstWhere((e) {
        bool ret = false;
        RegExp(e).allMatches(text).forEach((element) {
          if (element.group(0) == match[0]) {
            patternMached = e;
            ret = true;
          }
        });
        // Not Solve
        return ret;
      })];
      if (patternMached == r"_(.*?)\_") {
        formatText = match[0]!.replaceAll("_", " ");
      } else if (patternMached == r'\*(.*?)\*') {
        formatText = match[0]!.replaceAll("*", " ");
      } else if (patternMached == "~(.*?)~") {
        formatText = match[0]!.replaceAll("-", " ");
      } else if (patternMached == r'```(.*?)```') {
        formatText = match[0]!.replaceAll("```", " ");
      } else if (patternMached == r"-(.*?)\-") {
        formatText = match[0]!.replaceAll("-", " ");
      } else {
        formatText = match[0];
      }
      children.add(TextSpan(text: formatText, style: style!.merge(myStyle)));
      return "";
    }, onNonMatch: (String text) {
      children.add(TextSpan(text: text, style: style));
      return "";
    });
    return TextSpan(style: style, children: children);
  }
}
