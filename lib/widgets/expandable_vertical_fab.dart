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

/// Expendable [FloatingActionButton]
class ExpandableVerticalFAB extends StatefulWidget {
  final FabController fabController;
  final double distance;
  final double offsetY;
  final double offsetX;
  final List<Widget> children;
  final void Function(BuildContext)? onOpen;
  final void Function(BuildContext)? onClose;

  /// Constructor
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

  /// Override createState
  @override
  State<ExpandableVerticalFAB> createState() => _ExpandableVerticalFABState();
}

/// State for [ExpandableVerticalFAB]
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

  /// Open the FAB
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

  /// Close the FAB
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

  /// Toggle the state of the FAB
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

  /// Create the toggle button
  Widget _getToggleButton() {
    return Transform.rotate(
      angle: _buttonRotationAnimation.value,
      child: IgnorePointer(
        ignoring: false,
        child: FloatingActionButton(
          onPressed: () => _toggle(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Create the children that will be displayed vertically
  List<Widget> _createVerticalChildren() {
    final verticalChildren = <Widget>[];

    /// Add every child to verticalChildren and apply its animation
    widget.children.asMap().forEach((index, child) {
      final endBottom = widget.offsetY + widget.distance * (index + 1);

      verticalChildren.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: animationTime),
          curve: Curves.fastOutSlowIn,
          bottom: _isOpen ? endBottom : 20.0,
          right: widget.offsetX,
          child: IgnorePointer(
              ignoring: !_isOpen,
              child: Opacity(opacity: _buttonOpacityAnimation.value, child: child)),
        ),
      );
    });

    return verticalChildren;
  }

  /// Override initState
  ///
  /// Create the animations
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

  /// Override build
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
            _getToggleButton(),
            ..._createVerticalChildren(),
          ],
        ),
      ),
    );
  }
}
