import 'dart:ui';

import 'package:flutter/material.dart';

const defaultDistance = 50.0;
const defaultOffsetY = 50.0;
const defaultOffsetX = 10.0;

class ExpandableVerticalFAB extends StatefulWidget {
  final double distance;
  final double offsetY;
  final double offsetX;
  final List<Widget> children;
  final void Function(BuildContext)? onOpen;
  final void Function(BuildContext)? onClose;

  const ExpandableVerticalFAB({
    super.key,
    required this.children,
    this.distance = defaultDistance,
    this.offsetY = defaultOffsetY,
    this.offsetX = defaultOffsetX,
    this.onOpen,
    this.onClose,
  });

  @override
  State<ExpandableVerticalFAB> createState() => _ExpandableVerticalFABState();
}

class _ExpandableVerticalFABState extends State<ExpandableVerticalFAB> {
  bool _isOpen = false;

  void _toggle(BuildContext context) {
    setState(() {
      _isOpen = !_isOpen;

      if (_isOpen && widget.onOpen != null) {
        widget.onOpen!(context);
      } else if (widget.onClose != null) {
        widget.onClose!(context);
      }
    });
  }

  Widget _openButton() {
    return Opacity(
        opacity: _isOpen ? 0.0 : 1.0,
        child: IgnorePointer(
            ignoring: _isOpen,
            child: IconButton(
              onPressed: () => _toggle(context),
              icon: const Icon(Icons.add),
            )));
  }

  List<Widget> _createVerticalChildren() {
    final verticalChildren = <Widget>[
      Opacity(
        opacity: _isOpen ? 1.0 : 0.0,
        child: IconButton(
          onPressed: () => _toggle(context),
          icon: const Icon(Icons.close),
        ),
      ),
    ];

    if (_isOpen) {
      widget.children.asMap().forEach((index, child) {
        verticalChildren.add(Positioned(
          bottom: widget.offsetY + widget.distance * (index + 1),
          right: widget.offsetX,
          child: child,
        ));
      });
    }

    return verticalChildren;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _isOpen ? 5 : 0,
        sigmaY: _isOpen ? 5 : 0,
      ),
      child: SizedBox(
        height: (widget.children.length + 1) * widget.distance,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            _openButton(),
            ..._createVerticalChildren(),
          ],
        ),
      ),
    );
  }
}
