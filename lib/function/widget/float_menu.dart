import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
//import 'package:vector_math/vector_math_64.dart' as vector;

class FloatMenu extends StatefulWidget {
  final List<FloatingActionButton> listFloatingAction;
  FloatMenu({this.listFloatingAction});
  @override
  _FloatMenuState createState() {
    return _FloatMenuState(this.listFloatingAction);
  }
}

class _FloatMenuState extends State<FloatMenu> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  final List<FloatingActionButton> _listFloatingAction;
  _FloatMenuState(this._listFloatingAction);

  @override
  void initState() {
    this._animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _scaleAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.forward();

    super.initState();
  }

  @override
  dispose() {
    this._animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this._animationController.reverse();
    if (_listFloatingAction.length == 1) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: _listFloatingAction[0],
      );
    } else
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: new BoxDecoration(
            color: ColorConstant.BAR_MAIN,
            border: Border.all(
              width: 1,
              color: ColorConstant.BAR_MAIN,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              new BoxShadow(
                color: Color.fromRGBO(100, 100, 100, 1.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _listFloatingAction.length,
              (index) {
                return Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 3,
                    bottom: 3,
                  ),
                  child: _listFloatingAction.elementAt(index),
                );
              },
            ),
          ),
        ),
      );
  }
}
