import 'package:flutter/material.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/utils/extentions/primary_extensions.dart';
import 'primary_button.dart';

class LinkedText extends StatefulWidget {
  final String? text;
  final String link;
  final TextStyle? style;

  final OnPressedButton onLinkTap;
  final OnPressedButton? onTap;
  final Color? textColor;
  final bool disable;

  const LinkedText({
    super.key,
    this.text,
    required this.link,
    required this.onLinkTap,
    this.style,
    this.onTap,
    this.textColor,
    this.disable = false,
  });

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final style = (widget.style ?? Theme.of(context).textTheme.bodyLarge);
    final color = widget.disable ? Theme.of(context).unselectedWidgetColor : (widget.textColor ?? Theme.of(context).primaryColor).lighten(isHover ? 0.1 : 0);

    return Center(
      child: InkWell(
        onTap: widget.onTap,
        child: RichText(
          text: TextSpan(
            text: widget.text != null ? '${widget.text!} ' : null,
            style: style?.copyWith(
              color: widget.disable ? Theme.of(context).unselectedWidgetColor : Theme.of(context).canvasColor,
            ),
            children: [
              WidgetSpan(
                child: InkWell(
                  onTap: widget.disable ? null : widget.onLinkTap,
                  onHover: (v) => setState(() {
                    isHover = v;
                  }),
                  child: OkepointTexts.button(
                    widget.link,
                    context,
                    color: color,
                    fontWeight: FontWeight.w600,
                    titleStyle: widget.style?.copyWith(color: color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
