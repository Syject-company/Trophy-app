import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trophyapp/constants/theme_defaults.dart';

class TrophyDropdownButton<T> extends StatefulWidget {
  final String hint;
  final TextStyle hintStyle;
  final Widget leadingIcon;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T) onChanged;

  TrophyDropdownButton({
    this.hint,
    this.hintStyle,
    this.leadingIcon,
    this.value,
    this.onChanged,
    @required this.items,
  });

  @override
  _TrophyDropdownButtonState<T> createState() =>
      _TrophyDropdownButtonState<T>();
}

class _TrophyDropdownButtonState<T> extends State<TrophyDropdownButton<T>> {
  OverlayState _overlayState;
  OverlayEntry _overlayDropdown;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final position = button.localToGlobal(Offset.zero);
        final maxHeight =
            MediaQuery.of(context).size.height - (position.dy + 48.5) - 10;
        _overlayState = Overlay.of(context);
        _overlayDropdown = OverlayEntry(
          builder: (context) {
            return Stack(
              children: [
                GestureDetector(
                  onVerticalDragStart: (_) {
                    _overlayDropdown.remove();
                  },
                  onTap: () {
                    _overlayDropdown.remove();
                  },
                ),
                Positioned(
                  top: position.dy + 48.5,
                  left: position.dx,
                  child: Material(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 24,
                          right: 21.56,
                          bottom: 27,
                          left: 21,
                        ),
                        width: button.size.width,
                        constraints: BoxConstraints(
                          maxHeight: maxHeight,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F7),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(
                            color: Color(0xFF434345),
                            width: 1.5,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: widget.items.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.onChanged(
                                    widget.items[index].value as dynamic);
                                _overlayDropdown.remove();
                              },
                              child: widget.items[index].child,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        FocusScope.of(context).unfocus();
        _overlayState.insert(_overlayDropdown);
      },
      child: SizedBox(
        height: 50.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 21.0),
                      widget.leadingIcon ?? SizedBox.shrink(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Center(child: _getText()),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 21.0,
                  child: SvgPicture.asset(
                    'assets/img/dropdown_icon.svg',
                    color: ThemeDefaults.primaryTextColor,
                  ),
                ),
              ],
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
              color: _isSelected
                  ? ThemeDefaults.primaryColor
                  : ThemeDefaults.primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getText() {
    final selectedItem = widget.items
        .firstWhere((item) => item.value == widget.value, orElse: () => null);
    if (selectedItem == null) {
      return Text(widget.hint, style: widget.hintStyle);
    }

    _isSelected = true;

    return Text(
      selectedItem.value.toString(),
      style: GoogleFonts.raleway(
        fontSize: 13.0,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w800,
        color: ThemeDefaults.primaryTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}
