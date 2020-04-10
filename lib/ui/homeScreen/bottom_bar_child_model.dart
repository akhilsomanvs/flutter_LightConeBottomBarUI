import 'package:flutter/material.dart';

class BottomBarChildModel {
  List<_BottomBarChild> children = [];
  int defaultSelectedIndex = 0;
  int previousSelectedIndex = 0;
  int currentSelectedIndex = 1;

  double changingValue = 0.0;

  bool shouldShowLightCone = true;

  BottomBarChildModel() {
    changingValue = currentSelectedIndex.toDouble();
  }

  void addChild({IconData iconData, Function onTap}) {
    children.add(_BottomBarChild(parent: this, index: children.length, iconData: iconData, onTap: onTap));
  }

  void clearAllChildren() {
    children.clear();
  }

  void setChildAsSelected(_BottomBarChild child) {
    int index = children.indexOf(child);
    int currentSelectedChildIndex = children.indexWhere((item) {
      return item.isSelected;
    });
    if (currentSelectedChildIndex >= 0) {
      children[currentSelectedChildIndex].isSelected = false;
    }
    if (index >= 0) {
      previousSelectedIndex = currentSelectedChildIndex;
      currentSelectedIndex = index;
      children[currentSelectedIndex].isSelected = true;
    }
  }
}

class _BottomBarChild {
  IconData iconData;
  Function onTap;
  Function onClick;
  bool isSelected = false;
  int index;

  _BottomBarChild({@required BottomBarChildModel parent, @required this.index, @required this.iconData, Function onTap}) {
    isSelected = index == parent.currentSelectedIndex;
    if (onTap == null) {
      onTap = () {};
    }

    this.onClick = () {
      //set this child as selected
      parent.setChildAsSelected(this);
      //Execute the passed in method
      onTap();
    };
  }
}
