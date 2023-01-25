import 'package:flutter/material.dart';

class ExpandableOverlayWidgetController {
  OverlayEntry? _entry;

  /// must be call controller.show();
  late VoidCallback _show;

  /// must be call controller.hide();
  late VoidCallback _hide;
  bool _entryIsVisible = false;

  bool get isVisible => expand;

  bool expand = false;

  void show() {
    _entryIsVisible = true;
    _show();
  }

  void hide() {
    _entryIsVisible = false;
    _hide();
  }
}

class ExpandableOverlayWidget extends StatefulWidget {
  /// it work when Click Parent Widget
  final Function? onPressed;

  /// Expanding duration.
  final Duration? duration;

  /// Expanding forward animation.
  final Curve? forwardCurve;

  /// Expanding reverse animation.
  final Curve? reverseCurve;

  /// This widget always show.
  final Widget parentWidget;

  /// if pressed parentWidget it auto show overlay widget.
  /// [Default] value "true".
  final bool? autoOnPressedOff;

  ///  this widget show in overly
  final Widget overlayWidget;

  /// using this controller, you can control overlay widget
  /// [Show],[Hide]
  final ExpandableOverlayWidgetController controller;

  /// it works to add a gap between [parent] a [overlay] widget
  final double? gap;

  /// you can set overlay size .by default parent size
  final Size? size;

  /// The first argument sets [dx], the horizontal component,
  /// ? = any double value , Default "0" , that mane overlay widget center in parent widget  .
  ///  use "-?" it add padding in right side, use "?" for left side padding
  final double? offsetDx;

  final double? elevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final BorderRadiusGeometry? borderRadius;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final Function(bool)? onStatesChange;

  const ExpandableOverlayWidget({
    Key? key,
    this.duration,
    required this.parentWidget,
    required this.overlayWidget,
    required this.controller,
    this.forwardCurve,
    this.reverseCurve,
    this.autoOnPressedOff = true,
    this.size,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.borderRadius,
    this.clipBehavior = Clip.hardEdge,
    this.gap = 0.0,
    this.offsetDx = 0.0,
    this.onPressed,
    this.shape,
    this.onStatesChange,
  }) : super(key: key);

  @override
  _ExpandableOverlayWidgetState createState() =>
      _ExpandableOverlayWidgetState();
}

class _ExpandableOverlayWidgetState extends State<ExpandableOverlayWidget> {
  final layerLink = LayerLink();

  late ExpandableOverlayWidgetController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller._show = _showOverlay;
    _controller._hide = _hideOverlay;
    super.initState();
  }

  @override
  void dispose() {
    _controller._entry?.dispose();
    super.dispose();
  }

  _showOverlay() {
    if (_controller._entry != null) return;
    _controller.expand = true;
    final renderBox = context.findRenderObject() as RenderBox;
    final parentSize = renderBox.size;
    final size = widget.size ?? parentSize;

    _controller._entry = OverlayEntry(builder: (context) {
      return Positioned(
        width: size.width,
        child: CompositedTransformFollower(
            link: layerLink,
            offset: Offset(widget.offsetDx!, size.height + widget.gap!),
            child: _overlayWidget()),
      );
    });

    final overlay = Overlay.of(context)!;
    overlay.insert(_controller._entry!);
    _controller._entryIsVisible = true;
    if (widget.onStatesChange != null) {
      widget.onStatesChange!(_controller.expand);
    }
  }

  // we first finish expanding off animation,
  // then  remove _entry and set it null for make new one.
  _hideOverlay() {
    if (_controller._entry == null) return;
    _controller.expand = false;
    _controller._entry?.markNeedsBuild();
    _controller._entryIsVisible = false;
    if (widget.onStatesChange != null) {
      widget.onStatesChange!(_controller.expand);
    }
  }

  _onAnimationComplete() {
    _controller._entry?.remove();
    _controller._entry = null;
  }

  Widget _overlayWidget() {
    return Material(
      color: widget.backgroundColor,
      shadowColor: widget.shadowColor,
      elevation: widget.elevation ?? 0.0,
      clipBehavior: widget.clipBehavior,
      shape: widget.shape ?? _getDefaultShapeStyle(),
      child: _ExpandWidget(
        expand: _controller.expand,
        expandingComplete: () {
          _onAnimationComplete();
        },
        axis: Axis.vertical,
        duration: widget.duration,
        forwardCurve: widget.forwardCurve,
        reverseCurve: widget.reverseCurve,
        child: widget.overlayWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: _getParentWidget(),
    );
  }

  _getParentWidget() {
    if (widget.autoOnPressedOff!) {
      return GestureDetector(
        onTap: () {
          if (widget.onStatesChange != null) {
            widget.onStatesChange!(_controller.expand);
          }
          if (!_controller.expand) {
            _showOverlay();
          } else {
            _hideOverlay();
          }

          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: widget.parentWidget,
      );
    } else {
      return widget.parentWidget;
    }
  }

  ShapeBorder _getDefaultShapeStyle() {
    return RoundedRectangleBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
    );
  }
}

class _ExpandWidget extends StatefulWidget {
  final bool expand;
  final Widget child;
  final Duration? duration;
  final Axis axis;
  final Function expandingComplete;
  final Curve? forwardCurve;
  final Curve? reverseCurve;

  const _ExpandWidget({
    Key? key,
    required this.expand,
    required this.child,
    this.duration,
    this.axis = Axis.vertical,
    required this.expandingComplete,
    this.forwardCurve,
    this.reverseCurve,
  }) : super(key: key);

  @override
  _ExpandWidgetStateful createState() => _ExpandWidgetStateful();
}

class _ExpandWidgetStateful extends State<_ExpandWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 700));
    animation = CurvedAnimation(
        parent: expandController,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn);
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse().whenComplete(() {
        widget.expandingComplete();
      });
    }
  }

  @override
  void didUpdateWidget(_ExpandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: widget.axis,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
