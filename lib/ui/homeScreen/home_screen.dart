import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lightanimatedtabbar/ui/homeScreen/bottom_bar_child_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * Add item and Click events for Bottom Bar
     * */
    final bottomBarModel = BottomBarChildModel();
    bottomBarModel.addChild(iconData: Icons.home, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.search, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.fiber_new, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.add_a_photo, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.shopping_cart, onTap: () {});
    bottomBarModel.selectChildAtIndex(2);

    return SafeArea(
      child: Container(
        color: Colors.black12,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black45,
              ),
            ),
            BottomLightNavBar(bottomBarModel: bottomBarModel),
          ],
        ),
      ),
    );
  }
}

class BottomLightNavBar extends StatefulWidget {
  final BottomBarChildModel bottomBarModel;

  BottomLightNavBar({@required this.bottomBarModel});

  @override
  _BottomLightNavBarState createState() => _BottomLightNavBarState();
}

class _BottomLightNavBarState extends State<BottomLightNavBar> with SingleTickerProviderStateMixin {
  AnimationController animController;

  @override
  void initState() {
    super.initState();
    /**
     * Animation
     * */
    animController = AnimationController(vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        int previousSelectedIndex = widget.bottomBarModel.previousSelectedIndex;
        int destIndex = widget.bottomBarModel.currentSelectedIndex;

        setState(() {
          if (animController.status != AnimationStatus.dismissed) {
            widget.bottomBarModel.shouldShowLightCone = false;
            widget.bottomBarModel.changingValue = lerpDouble(previousSelectedIndex, destIndex, animController.value);
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animController.reset();
          widget.bottomBarModel.shouldShowLightCone = true;
        }
      });
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black54,
      child: CustomPaint(
        /**
         * Since the custom painting has to be done over the child widget,
         * we use "foregroundPainter" instead of just "painter"
         * */
        foregroundPainter: BottomBarLightConePainter(
          shouldShowLightCone: widget.bottomBarModel.shouldShowLightCone,
          itemCount: widget.bottomBarModel.children.length,
          selectedItemIndex: widget.bottomBarModel.changingValue,
          shouldShowTrack: false,
        ),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.bottomBarModel.children.map((childItem) {
              return GestureDetector(
                child: Icon(
                  childItem.iconData,
                  /**
                   * Only activate the icon when selected and the light cone is shown as well.
                   * */
                  color: childItem.isSelected && widget.bottomBarModel.shouldShowLightCone ? Colors.white : Colors.black38,
                ),
                onTap: () {
                  childItem.onClick();
                  animController.forward();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomBarLightConePainter extends CustomPainter {
  final int itemCount;
  final double selectedItemIndex;

  final Paint trackPaint;
  final Paint thumbPaint;
  final double thumbPositionPercent;

  final double topLightHeight = 4;
  final bool shouldShowLightCone;
  bool shouldShowTrack = true;
  Gradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.1),
    ],
    stops: [
      0.0,
      0.8,
    ],
  );

  BottomBarLightConePainter({@required this.shouldShowLightCone, @required this.itemCount, @required this.selectedItemIndex, this.shouldShowTrack = true, Gradient lightConeGradient})
      : trackPaint = Paint()
          ..color = Colors.black38
          ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
        thumbPositionPercent = selectedItemIndex / itemCount.toDouble() {
    if (lightConeGradient != null) {
      this.lightGradient = lightConeGradient;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //Draw track
    if (shouldShowTrack) {
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
              0.0,
              0.0,
              size.width,
              topLightHeight,
            ),
            topLeft: Radius.circular(3.0),
            topRight: Radius.circular(3.0),
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(3.0),
          ),
          trackPaint);
    }

    //Draw Thumb
    final thumbChamberWidth = size.width / itemCount;
    final thumbChamberStartPoint = thumbChamberWidth * selectedItemIndex;
    final thumbChamberHalfWidth = thumbChamberWidth / 2;
    final thumbCenterPoint = thumbChamberStartPoint + thumbChamberHalfWidth;
    final thumbWidth = thumbChamberWidth / 4;
    final thumbLeft = thumbCenterPoint - thumbWidth / 2;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            thumbLeft,
            0.0,
            thumbWidth,
            topLightHeight,
          ),
          topLeft: Radius.circular(3.0),
          topRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0),
        ),
        thumbPaint);

    //Draw Light cone
    if (shouldShowLightCone) {
      final lightConeRect = Rect.fromLTWH(thumbChamberStartPoint, topLightHeight, thumbChamberWidth, size.height);
      thumbPaint.shader = lightGradient.createShader(lightConeRect);
      canvas.drawPath(
        returnTrapezoidPath(rect: lightConeRect, topWidth: thumbWidth.toInt(), bottomWidth: thumbChamberWidth.toInt()),
        thumbPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// Returns a trapezoidal path for the [rect] given,
  /// with the [topWidth] as the length of the top side and [bottomWidth] as the length of the bottom side.
  Path returnTrapezoidPath({@required Rect rect, @required int topWidth, @required int bottomWidth}) {
    final topStartPoint = Offset(rect.topCenter.dx - (topWidth / 2), rect.topCenter.dy);
    final bottomStartPoint = Offset(rect.bottomCenter.dx - (bottomWidth / 2), rect.bottomCenter.dy);
    return Path()
      ..moveTo(topStartPoint.dx, topStartPoint.dy)
      ..lineTo(topStartPoint.dx + topWidth, topStartPoint.dy)
      ..lineTo(bottomStartPoint.dx + bottomWidth, bottomStartPoint.dy)
      ..lineTo(bottomStartPoint.dx, bottomStartPoint.dy)
      ..close();
  }
}
