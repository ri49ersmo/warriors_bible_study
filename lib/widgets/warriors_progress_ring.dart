import 'package:flutter/material.dart';

class WarriorsProgressRing extends StatefulWidget {
  final int count;
  final int goal;

  const WarriorsProgressRing({
    super.key,
    required this.count,
    required this.goal,
  });

  @override
  State<WarriorsProgressRing> createState() => _WarriorsProgressRingState();
}

class _WarriorsProgressRingState extends State<WarriorsProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.count / widget.goal,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant WarriorsProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animation = Tween<double>(
      begin: oldWidget.count / oldWidget.goal,
      end: widget.count / widget.goal,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: 360,   // MUCH BIGGER circle
          height: 360,  // MUCH BIGGER circle
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background image will be added here next

              // Progress Ring
              SizedBox(
                width: 360,
                height: 360,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 20, // thicker ring for large size
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFD700), // gold
                  ),
                ),
              ),

              // Center Text
              Text(
                "${(widget.count / widget.goal * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
