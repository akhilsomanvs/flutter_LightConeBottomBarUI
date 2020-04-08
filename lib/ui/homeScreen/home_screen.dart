import 'package:flutter/material.dart';
import 'package:lightanimatedtabbar/ui/homeScreen/bottom_bar_child_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomBarModel = BottomBarChildModel();
    bottomBarModel.addChild(iconData: Icons.home, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.search, onTap: () {});
    bottomBarModel.addChild(iconData: Icons.fiber_new, onTap: () {});

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
  int itemCount;
  final BottomBarChildModel bottomBarModel;

  BottomLightNavBar({@required this.bottomBarModel}) {
    this.itemCount = bottomBarModel.children.length;
  }

  @override
  _BottomLightNavBarState createState() => _BottomLightNavBarState();
}

class _BottomLightNavBarState extends State<BottomLightNavBar> {
  @override
  Widget build(BuildContext context) {

    widget.bottomBarModel.children.forEach((item) {
      item.onTap = (){
        item.onClick();
        setState(() {

        });
      };
    });

    return Container(
      height: 60,
      color: Colors.black54,
      child: ScrollIndicator(
        bottomBarChildModel: widget.bottomBarModel,
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  int itemCount = 0;
  final int selectedItemIndex;

  final BottomBarChildModel bottomBarChildModel;

  ScrollIndicator({@required this.bottomBarChildModel, this.selectedItemIndex = 0}) {
    this.itemCount = bottomBarChildModel.children.length;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: ScrollIndicatorPainter(
        itemCount: itemCount,
        selectedItemIndex: bottomBarChildModel.currentSelectedIndex,
      ),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: bottomBarChildModel.children.map((childItem) {
            return GestureDetector(
              child: Icon(childItem.iconData,color: childItem.isSelected?Colors.white:Colors.black38,),
              onTap: () {
                childItem.onTap();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int itemCount;
  final int selectedItemIndex;

  final Paint trackPaint;
  final Paint thumbPaint;
  final double thumbPositionPercent;

  final double topLightHeight = 4;
  final Gradient lightGradient = LinearGradient(
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

  ScrollIndicatorPainter({this.itemCount, this.selectedItemIndex})
      : trackPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
        thumbPositionPercent = selectedItemIndex / itemCount.toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    //Draw track
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
    final drawRect = Rect.fromLTWH(thumbChamberStartPoint, 0.0, thumbChamberWidth, size.height);
    thumbPaint.shader = lightGradient.createShader(drawRect);
    canvas.drawPath(
      returnTrapezoidPath(rect: drawRect, topWidth: thumbWidth.toInt(), bottomWidth: thumbChamberHalfWidth.toInt()),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path returnTrapezoidPath({@required Rect rect, @required int topWidth, @required int bottomWidth}) {
    final topStartPoint = Offset(rect.topCenter.dx - (topWidth / 2), rect.topCenter.dy);
    final bottomStartPoint = Offset(rect.bottomCenter.dx - (bottomWidth / 2), rect.bottomCenter.dy);
    return Path()
      ..moveTo(topStartPoint.dx, topStartPoint.dy)
      ..lineTo(topStartPoint.dx + topWidth, topStartPoint.dy)..lineTo(bottomStartPoint.dx + bottomWidth, bottomStartPoint.dy)..lineTo(bottomStartPoint.dx, bottomStartPoint.dy)
      ..close();
  }
}
