import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';

class FancyBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final List<FancyBottomNavigationItem> items;
  final ValueChanged<int> onItemSelected;

  FancyBottomNavigation(
      {Key key,
      this.currentIndex = 0,
      this.iconSize = 24,
      this.activeColor,
      this.inactiveColor,
      this.backgroundColor,
      @required this.items,
      @required this.onItemSelected}) {
    assert(items != null);
    assert(onItemSelected != null);
  }

  @override
  _FancyBottomNavigationState createState() {
    return _FancyBottomNavigationState(
        items: items,
        backgroundColor: backgroundColor,
        currentIndex: currentIndex,
        iconSize: iconSize,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onItemSelected: onItemSelected);
  }
}

class _FancyBottomNavigationState extends State<FancyBottomNavigation> {
  final int currentIndex;
  final double iconSize;
  Color activeColor;
  Color inactiveColor;
  Color backgroundColor;
  List<FancyBottomNavigationItem> items;
  int _selectedIndex;
  ValueChanged<int> onItemSelected;

  _FancyBottomNavigationState(
      {@required this.items,
      this.currentIndex,
      this.activeColor,
      this.inactiveColor = Colors.black,
      this.backgroundColor,
      this.iconSize,
      @required this.onItemSelected}) {
    _selectedIndex = currentIndex;
  }

  Widget _buildItem(FancyBottomNavigationItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected
          ? ScreenSizeConfig.blockSizeHorizontal * 35
          : ScreenSizeConfig.blockSizeHorizontal * 20,
      height: double.maxFinite,
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(
          ScreenSizeConfig.blockSizeHorizontal * 1.5,
          ScreenSizeConfig.blockSizeVertical * .3,
          ScreenSizeConfig.blockSizeHorizontal * 1.5,
          ScreenSizeConfig.blockSizeVertical * .3),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
            ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          left: 2,
          right: 2,
        ),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color: isSelected
                          ? ColorConstant.ACTIVE_TEXT
                          : inactiveColor),
                  child: item.icon,
                ),
              ),
              isSelected
                  ? DefaultTextStyle.merge(
                      style: TextStyle(color: ColorConstant.ACTIVE_TEXT),
                      child: item.title,
                    )
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeColor =
        (activeColor == null) ? Theme.of(context).accentColor : activeColor;

    backgroundColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: ScreenSizeConfig.blockSizeVertical * 7,
      padding: EdgeInsets.only(
        left: ScreenSizeConfig.blockSizeVertical * 0.8,
        right: ScreenSizeConfig.blockSizeVertical * 0.8,
        top: ScreenSizeConfig.blockSizeVertical * 0.5,
        bottom: ScreenSizeConfig.blockSizeVertical * 0.5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items.map((item) {
          var index = items.indexOf(item);
          return _buildTabItem(item, index);
        }).toList(),
      ),
    );
  }

//shape: CircularNotchedRectangle(),
  Widget _buildTabItem(FancyBottomNavigationItem item, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onItemSelected(index);

          setState(() {
            _selectedIndex = index;
          });
        },
        child: _buildItem(item, _selectedIndex == index),
      ),
    );
  }
}

class FancyBottomNavigationItem {
  final Icon icon;
  final Text title;

  FancyBottomNavigationItem({
    @required this.icon,
    @required this.title,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
