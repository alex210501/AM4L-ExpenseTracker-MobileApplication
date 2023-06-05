import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/services/fab_controller.dart';

const defaultDistance = 50.0;
const defaultOffsetY = 50.0;
const defaultOffsetX = 10.0;
const animationTime = 500; // milliseconds

/// Convert degrees to radians
double degreeToRadian(double degrees) => degrees * pi / 180;

class ExpandableVerticalFAB extends StatefulWidget {
  final FabController fabController;
  final double distance;
  final double offsetY;
  final double offsetX;
  final List<Widget> children;
  final void Function(BuildContext)? onOpen;
  final void Function(BuildContext)? onClose;

  const ExpandableVerticalFAB({
    super.key,
    required this.children,
    required this.fabController,
    this.distance = defaultDistance,
    this.offsetY = defaultOffsetY,
    this.offsetX = defaultOffsetX,
    this.onOpen,
    this.onClose,
  });

  @override
  State<ExpandableVerticalFAB> createState() => _ExpandableVerticalFABState();
}

class _ExpandableVerticalFABState extends State<ExpandableVerticalFAB>
    with TickerProviderStateMixin {
  bool _isOpen = false;
  late final AnimationController _buttonOpacityController;
  late final Animation<double> _buttonOpacityAnimation;
  late final AnimationController _buttonRotationController;
  late final Animation<double> _buttonRotationAnimation;

  /// Forward all animation
  void _forwardAnimation() {
    _buttonOpacityController.forward();
    _buttonRotationController.forward();
  }

  /// Reverse all animation
  void _reverseAnimation() {
    _buttonOpacityController.reverse();
    _buttonRotationController.reverse();
  }

  void _open(BuildContext context) {
    setState(() {
      _isOpen = true;

      // Execute the callback
      if (widget.onOpen != null) {
        widget.onOpen!(context);
      }
    });

    _forwardAnimation();
  }

  void _close(BuildContext context) {
    setState(() {
      _isOpen = false;

      // Execute the callback
      if (widget.onClose != null) {
        widget.onClose!(context);
      }
    });

    _reverseAnimation();
  }

  void _toggle(BuildContext context) {
    setState(() {
      _isOpen = !_isOpen;

      if (_isOpen) {
        _forwardAnimation();
      } else {
        _reverseAnimation();
      }

      if (_isOpen && widget.onOpen != null) {
        _open(context);
      } else if (widget.onClose != null) {
        _close(context);
      }
    });
  }

  Widget _openButton() {
    return Transform.rotate(
        // opacity: _isOpen ? 0.0 : 1.0,
        angle: _buttonRotationAnimation.value,
        child: IgnorePointer(
            ignoring: false,
            child: FloatingActionButton(
              onPressed: () => _toggle(context),
              child: const Icon(Icons.add),
            )));
  }

  List<Widget> _createVerticalChildren() {
    final verticalChildren = <Widget>[];

    // if (_isOpen) {
    widget.children.asMap().forEach((index, child) {
      final endBottom = widget.offsetY + widget.distance * (index + 1);

      verticalChildren.add(AnimatedPositioned(
        duration: const Duration(milliseconds: animationTime),
        curve: Curves.fastOutSlowIn,
        bottom: _isOpen ? endBottom : 20.0, // _animations[_animations.length - 1].value,
        right: widget.offsetX,
        // onEnd: () => setState(() => _buttonOpacity = _isOpen ? 1.0 : 0.0),
        child: IgnorePointer(
          ignoring: !_isOpen,
          child: Opacity(
            opacity: _buttonOpacityAnimation.value,
            child: child,
          ),
        ),
      ));
    });
    // }

    return verticalChildren;
  }

  @override
  void initState() {
    super.initState();

    // Set animations
    _buttonOpacityController = AnimationController(
      duration: const Duration(milliseconds: animationTime),
      vsync: this,
    )..addListener(() => setState(() {}));
    _buttonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _buttonOpacityController,
      curve: const Interval(0.0, 0.5),
    ));

    // Animation for the rotation
    _buttonRotationController = AnimationController(
      duration: const Duration(milliseconds: animationTime),
      vsync: this,
    );

    _buttonRotationAnimation = Tween<double>(begin: 0.0, end: degreeToRadian(45.0)).animate(
      CurvedAnimation(
        parent: _buttonRotationController,
        curve: Curves.easeIn,
      ),
    )..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // Set the controller function
    widget.fabController.open = () => _open(context);
    widget.fabController.close = () => _close(context);
    widget.fabController.toggle = () => _toggle(context);
    widget.fabController.getState = () => _isOpen;

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _isOpen ? 5 : 0,
        sigmaY: _isOpen ? 5 : 0,
      ),
      child: SizedBox(
        height: (widget.children.length + 1) * widget.distance,
        width: 50,
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
