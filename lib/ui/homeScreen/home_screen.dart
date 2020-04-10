import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lightanimatedtabbar/ui/customWidgets/bottomLightNavBar/bottom_bar_child_model.dart';
import 'package:lightanimatedtabbar/ui/customWidgets/bottomLightNavBar/bottom_light_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int iconIndex;
  final bottomBarModel = BottomBarChildModel();

  void executeOnTap(int index) {
    setState(() {
      iconIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    /**
     * Add item and Click events for Bottom Bar
     * */
    bottomBarModel.addChild(iconData: Icons.home, onTap: executeOnTap);
    bottomBarModel.addChild(iconData: Icons.search, onTap: executeOnTap);
    bottomBarModel.addChild(iconData: Icons.fiber_new, onTap: executeOnTap);
    bottomBarModel.addChild(iconData: Icons.add_a_photo, onTap: executeOnTap);
    bottomBarModel.addChild(iconData: Icons.shopping_cart, onTap: executeOnTap);


    int selectedIndex = 2;
    bottomBarModel.selectChildAtIndex(selectedIndex);
    iconIndex=selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black12,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Clicked Icon Index',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '$iconIndex',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomLightNavBar(bottomBarModel: bottomBarModel),
          ],
        ),
      ),
    );
  }
}