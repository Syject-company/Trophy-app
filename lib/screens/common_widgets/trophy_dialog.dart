import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrophyDialog extends StatelessWidget {
  final Widget child;

  TrophyDialog({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<List<DrawableRoot>>(
        future: _loadSvgs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomPaint(
              painter: _DialogPainter(svgs: snapshot.data),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 102.8,
                  right: 8,
                  bottom: 103.8,
                  left: 8,
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
      ),
    );
  }

  Future<List<DrawableRoot>> _loadSvgs() async {
    return [
      await svg.fromSvgString(
          await rootBundle.loadString('assets/img/dialog_frame.svg'),
          'SVG_DEBUG'),
      await svg.fromSvgString(
          await rootBundle.loadString('assets/img/dialog_top.svg'),
          'SVG_DEBUG'),
      await svg.fromSvgString(
          await rootBundle.loadString('assets/img/dialog_bottom.svg'),
          'SVG_DEBUG'),
    ];
  }
}

class _DialogPainter extends CustomPainter {
  List<DrawableRoot> svgs;
  _DialogPainter({this.svgs});

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final paint = Paint()
      ..color = Color(0xFFEBEBEC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const offset = 4.0;
    final frameBounds = Rect.fromPoints(Offset(offset, offset),
        Offset(size.width - offset, size.height - offset));
    final frame = RRect.fromRectAndRadius(
      frameBounds,
      Radius.circular(10.5),
    );
    canvas.drawRRect(frame, paint);

    // draw top part
    Size desiredSize = Size(size.width - offset * 4, 94.8);

    canvas.save();
    canvas.translate(offset * 2, offset * 2);
    Size svgSize = svgs[1].viewport.size;
    var matrix = Matrix4.identity();
    matrix.scale(
        desiredSize.width / svgSize.width, desiredSize.height / svgSize.height);
    canvas.transform(matrix.storage);
    svgs[1].draw(canvas,
        null); // the second argument is not used in DrawableRoot.draw() method
    canvas.restore();

    // draw bottom part
    desiredSize = Size(size.width - offset * 4, 95.8);
    canvas.save();
    canvas.translate(offset * 2, size.height - offset * 2 - desiredSize.height);
    svgSize = svgs[2].viewport.size;
    matrix = Matrix4.identity();
    matrix.scale(
        desiredSize.width / svgSize.width, desiredSize.height / svgSize.height);
    canvas.transform(matrix.storage);
    svgs[2].draw(canvas,
        null); // the second argument is not used in DrawableRoot.draw() method
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
