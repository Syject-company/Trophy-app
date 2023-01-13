import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final Widget icon;

  const CustomListTile({
    Key key,
    this.image,
    this.title,
    this.subtitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            offset: Offset(0, 2),
            blurRadius: 3,
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 7,
            right: 9.5,
            child: icon ?? SizedBox.shrink(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  widthFactor: 168,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                      bottom: 3.8,
                    ),
                    child: image ??
                        SizedBox(
                          height: 44,
                          width: double.infinity,
                          child:
                              SvgPicture.asset('assets/img/trophys_icon.svg'),
                        ),
                  ),
                ),
              ),
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.raleway(
                  color: Color(image == null ? 0xFFA7A9AC : 0xFF333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 4,
                  bottom: 20,
                ),
                child: Text(
                  subtitle ?? '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                    color: Color(image == null ? 0xFFA7A9AC : 0xFF4F4F4F),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
