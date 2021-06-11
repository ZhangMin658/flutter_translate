import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final double translateXBegin;
  final double translateXEnd;

  FadeIn({
    @required this.delay,
    @required this.translateXBegin,
    @required this.translateXEnd,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateX").add(Duration(milliseconds: 500),
          Tween(begin: translateXBegin, end: translateXEnd),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}

class SwitchAnimation extends StatelessWidget {
  final bool checked;
  final String textOn;
  final String textOff;
  final double size;
  final double heightOutSide;
  final double padding;
  final double borderWidth;
  final double borderRadius;
  final double textSize;
  final double textHeight;
  final int duarationRotation;
  final int duarationChangeText;
  final Color textColor;
  final Color colorBegin;
  final Color colorEnd;

  SwitchAnimation({
    this.checked,
    this.textOn,
    this.textOff,
    this.size,
    this.heightOutSide,
    this.padding,
    this.borderWidth,
    this.borderRadius,
    this.textSize,
    this.textColor,
    this.textHeight,
    this.duarationRotation,
    this.colorBegin,
    this.colorEnd,
    this.duarationChangeText,
  });

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft").add(
          Duration(milliseconds: duarationRotation ?? 1000),
          Tween(
            begin: 0.0,
            end: ((size ?? 0 / 2) - 5) <= 0 ? 20 : (size / 2) - 5,
          )),
      Track("color").add(
        Duration(milliseconds: duarationRotation ?? 1000),
        ColorTween(
          begin: colorBegin ?? Colors.grey,
          end: colorEnd ?? Colors.blue,
        ),
      ),
      Track("text")
          .add(Duration(milliseconds: duarationChangeText ?? 500),
              ConstantTween(textOff ?? 'OFF'))
          .add(Duration(milliseconds: duarationChangeText ?? 500),
              ConstantTween(textOn ?? 'ON')),
      Track("rotation").add(Duration(milliseconds: duarationRotation ?? 1000),
          Tween(begin: -2 * pi, end: 0.0))
    ]);

    return ControlledAnimation(
      playback: checked ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Container(
      decoration: _outerBoxDecoration(animation["color"]),
      width: size ?? 50,
      height: (size ?? 0 / 1.666666666) <= 0 ? 30 : (size / 1.666666666),
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          Positioned(
              child: Padding(
            padding: EdgeInsets.only(left: animation["paddingLeft"]),
            child: Transform.rotate(
              angle: animation["rotation"],
              child: Container(
                decoration: _innerBoxDecoration(animation["color"]),

                ///if size == null it will be equals 0 =>
                ///if size == 0, result of ((size / 2)- 5) will be smaller than 0 => return 20.
                ///if size != null, it won't equals 0 => then result will be equals (size / 2) - 5
                width: ((size ?? 0 / 2) - 5) <= 0 ? 20 : (size / 2) - 5,
                child: Center(
                  child: Text(
                    animation["text"],
                    style: TextStyle(
                      height: textHeight ?? 1.2,
                      fontWeight: FontWeight.bold,
                      fontSize: textSize ?? 9,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(
          (size ?? 0 / 2) <= 0 ? 25 : (size / 2),
        )),
        color: color,
      );

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 30)),
        border: Border.all(
          width: borderWidth ?? 2,
          color: color,
        ),
      );
}
