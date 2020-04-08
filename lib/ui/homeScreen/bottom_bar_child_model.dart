import 'package:flutter/material.dart';

class BottomBarChildModel {
  List<_BottomBarChild> children = [];
  int defaultSelectedIndex = 0;
  int currentSelectedIndex = 1;

  void addChild({IconData iconData, Function onTap}) {
    children.add(_BottomBarChild(parent: this, position: children.length, iconData: iconData, onTap: onTap));
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

  _BottomBarChild({@required BottomBarChildModel parent, @required int position, @required this.iconData, Function onTap}) {
    isSelected = position == parent.currentSelectedIndex;
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
