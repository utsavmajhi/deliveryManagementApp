import 'package:flutter/material.dart';

enum CircularButtonState { idle, loading, paused, playing }

class CircularButton extends StatefulWidget {
  final CircularButtonState state;
  final VoidCallback onPressed;
  final IconData idleIcon;

  const CircularButton({Key? key, this.state = CircularButtonState.idle, required this.onPressed,required this.idleIcon}) : super(key: key);

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CircularButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == CircularButtonState.loading) {
      _animationController.repeat(reverse: false);
    } else {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (widget.state) {
      case CircularButtonState.loading:
        icon = Icons.refresh;
        break;
      case CircularButtonState.paused:
        icon = Icons.pause;
        break;
      case CircularButtonState.playing:
        icon = Icons.play_arrow;
        break;
      case CircularButtonState.idle:
      default:
        icon = widget.idleIcon;
        break;
    }

    Color getColor(CircularButtonState state) {
      switch (state) {
        case CircularButtonState.loading:
          return Colors.grey;
        default:
          return Colors.blue;
      }
    }

    return InkWell(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle:widget.state ==CircularButtonState.idle ?0: _animationController.value * 6.3, // 6.3 radians = 360 degrees
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: getColor(widget.state),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
