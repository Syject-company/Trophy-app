import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrophyTitle extends StatelessWidget {
  final Text child;

  TrophyTitle({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DrawableRoot>(
      future: _loadFrame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CustomPaint(
            painter: _DialogPainter(frame: snapshot.data),
            child: Padding(
              padding: EdgeInsets.only(
                top: 35.5,
                bottom: 23,
              ),
              child: child,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<DrawableRoot> _loadFrame() async {
    return await svg.fromSvgString(
        await rootBundle.loadString('assets/img/title_frame.svg'), 'SVG_DEBUG');
  }
}

class _DialogPainter extends CustomPainter {
  DrawableRoot frame;
  _DialogPainter({this.frame});

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    // draw frame
    frame.scaleCanvasToViewBox(canvas, size);
    frame.clipCanvasToViewBox(canvas);
    frame.draw(canvas,
        null); // the second argument is not used in DrawableRoot.draw() method
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
